require 'multi_part_date/version'
require 'active_support/concern'
require 'active_support'
require 'date'
require 'reform'

module MultiPartDate
  extend ActiveSupport::Concern

  class_methods do
    def multi_part_date(field_name, options = {})
      key = options[:as] || field_name
      discard_options = options.slice(:discard_day, :discard_month, :discard_year)
      on_options = options.slice(:on)
      type = options[:type] || Types::Form::Date

      create_methods_for(field_name, key, discard_options)

      property :"#{key}_month", { type: Types::Form::Int, virtual: true }.merge(on_options)
      property :"#{key}_day", { type: Types::Form::Int, virtual: true }.merge(on_options)
      property :"#{key}_year", { type: Types::Form::Int, virtual: true }.merge(on_options)
      property field_name, { type: type }.merge(on_options)

      validate_if_required(field_name, options[:validate_if])
    end

    def create_methods_for(field_name, key, discard_options)
      create_date_values_methods_for(key)
      create_getters_for(field_name, key, discard_options)
      create_setters_for(field_name, key)
      create_validation_helper_methods_for(field_name, key)
    end

    def create_getters_for(field_name, key, discard_options)
      %i(day month year).each do |type|
        if discard_options[:"discard_#{type}"]
          define_method(:"#{key}_#{type}") do
            1
          end
        else
          define_method(:"#{key}_#{type}") do
            if send(field_name)
              send(field_name).send(type) if send(field_name).respond_to?(type)
            else
              super()
            end
          end
        end
      end
    end

    def create_setters_for(field_name, key)
      %i(day month year).each do |type|
        define_method(:"#{key}_#{type}=") do |value|
          super(value)

          send(:"set_#{field_name}") if send(:"#{field_name}_parts_present?")
        end
      end

      define_method(:"set_#{field_name}") do
        return nil unless send(:"valid_#{field_name}_date?")

        date = ::Date.new(
          send(:"#{key}_year_value"),
          send(:"#{key}_month_value"),
          send(:"#{key}_day_value")
        )

        send(:"#{field_name}=", date)
      end
    end

    def validate_if_required(field_name, validate_if_option)
      if validate_if_option
        validate :"validate_#{field_name}_date", if: validate_if_option
      else
        validate :"validate_#{field_name}_date"
      end
    end

    def create_date_values_methods_for(key)
      %i(day month year).each do |type|
        define_method(:"#{key}_#{type}_value") do
          send(:"#{key}_#{type}").to_i
        end
      end
    end

    def create_validation_helper_methods_for(field_name, key)
      create_valid_date_method_for(field_name, key)
      create_parts_present_method_for(field_name, key)
      create_validate_date_method_for(field_name)
    end

    def create_valid_date_method_for(field_name, key)
      define_method(:"valid_#{field_name}_date?") do
        ::Date.valid_date?(
          send(:"#{key}_year_value"),
          send(:"#{key}_month_value"),
          send(:"#{key}_day_value")
        )
      end
    end

    def create_parts_present_method_for(field_name, key)
      define_method(:"#{field_name}_parts_present?") do
        send(:"#{field_name}=", nil)

        [
          send(:"#{key}_year_value"),
          send(:"#{key}_month_value"),
          send(:"#{key}_day_value")
        ].all?(&:present?)
      end
    end

    def create_validate_date_method_for(field_name)
      define_method(:"validate_#{field_name}_date") do
        return true if send(:"valid_#{field_name}_date?")

        errors.add(field_name, 'is not a valid date')
      end
    end
  end
end
