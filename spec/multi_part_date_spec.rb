require 'spec_helper'
require 'pry'

Reform::Form.reform_2_0!

describe MultiPartDate do
  let(:model) do
    double(
      :model,
      'date_of_birth=': true,
      date_of_birth: true,
      save: true
    )
  end

  it 'has a version number' do
    expect(MultiPartDate::VERSION).not_to be nil
  end

  context 'when no options are given' do
    let(:form) { DummyForm.new(model) }

    context 'when the date has all 3 parts' do
      context 'and the date is valid' do
        let(:params) do
          {
            date_of_birth_month: 12,
            date_of_birth_day: 25,
            date_of_birth_year: 2000
          }
        end

        it 'sets the date on the model' do
          form.validate(params) && form.save

          expect(model).to have_received(:date_of_birth=).with(Date.new(2000, 12, 25))
        end

        it 'does not add errors to the form' do
          form.validate(params) && form.save

          expect(form.errors.full_messages).to be_blank
        end
      end

      context 'when the date is invalid' do
        let(:params) do
          {
            date_of_birth_month: 12,
            date_of_birth_day: 50,
            date_of_birth_year: 2000
          }
        end

        it 'does not set the date on the model' do
          form.validate(params) && form.save

          expect(model).not_to have_received(:date_of_birth=)
        end

        it 'adds an error to the form' do
          form.validate(params) && form.save

          expect(form.errors.full_messages).to eq ['Date of birth is not a valid date']
        end
      end
    end

    context 'when the date does not have all 3 parts' do
      let(:params) do
        {
          date_of_birth_month: 12,
          date_of_birth_day: nil,
          date_of_birth_year: 2000
        }
      end

      it 'does not set the date on the model' do
        form.validate(params) && form.save

        expect(model).not_to have_received(:date_of_birth=)
      end

      it 'adds an error to the form' do
        form.validate(params) && form.save

        expect(form.errors.full_messages).to eq ['Date of birth is not a valid date']
      end
    end
  end

  context 'when :as option is given' do
    let(:form) { DummyFormWithAsOption.new(model) }

    context 'when the date has all 3 parts' do
      context 'and the date is valid' do
        let(:params) do
          {
            birth_month: 12,
            birth_day: 25,
            birth_year: 2000
          }
        end

        it 'sets the date on the model' do
          form.validate(params) && form.save

          expect(model).to have_received(:date_of_birth=).with(Date.new(2000, 12, 25))
        end

        it 'does not add errors to the form' do
          form.validate(params) && form.save

          expect(form.errors.full_messages).to be_blank
        end
      end

      context 'when the date is invalid' do
        let(:params) do
          {
            birth_month: 12,
            birth_day: 50,
            birth_year: 2000
          }
        end

        it 'does not set the date on the model' do
          form.validate(params) && form.save

          expect(model).not_to have_received(:date_of_birth=)
        end

        it 'adds an error to the form' do
          form.validate(params) && form.save

          expect(form.errors.full_messages).to eq ['Date of birth is not a valid date']
        end
      end
    end

    context 'when the date does not have all 3 parts' do
      let(:params) do
        {
          birth_month: 12,
          birth_day: nil,
          birth_year: 2000
        }
      end

      it 'does not set the date on the model' do
        form.validate(params) && form.save

        expect(model).not_to have_received(:date_of_birth=)
      end

      it 'adds an error to the form' do
        form.validate(params) && form.save

        expect(form.errors.full_messages).to eq ['Date of birth is not a valid date']
      end
    end
  end

  context 'when :discard_day, :discard_month or :doscard_year option is given' do
    let(:form) { DummyFormWithDiscardOption.new(model) }

    context 'when the date has the other 2 required parts' do
      context 'and the date is valid' do
        let(:params) do
          {
            date_of_birth_month: 12,
            date_of_birth_year: 2000
          }
        end

        it 'sets the date on the model' do
          form.validate(params) && form.save

          expect(model).to have_received(:date_of_birth=).with(Date.new(2000, 12, 01))
        end

        it 'does not add errors to the form' do
          form.validate(params) && form.save

          expect(form.errors.full_messages).to be_blank
        end
      end

      context 'when the date is invalid' do
        let(:params) do
          {
            date_of_birth_month: 14,
            date_of_birth_year: 2000
          }
        end

        it 'does not set the date on the model' do
          form.validate(params) && form.save

          expect(model).not_to have_received(:date_of_birth=)
        end

        it 'adds an error to the form' do
          form.validate(params) && form.save

          expect(form.errors.full_messages).to eq ['Date of birth is not a valid date']
        end
      end
    end

    context 'when the date does not have the other 2 required parts' do
      let(:params) do
        {
          date_of_birth_year: 2000
        }
      end

      it 'does not set the date on the model' do
        form.validate(params) && form.save

        expect(model).not_to have_received(:date_of_birth=)
      end

      it 'adds an error to the form' do
        form.validate(params) && form.save

        expect(form.errors.full_messages).to eq ['Date of birth is not a valid date']
      end
    end
  end

  context 'when :on option is given' do
    let(:form) { DummyFormWithOnOption.new(model) }

    let(:nested_model) do
      double(
        :nested_model,
        'date_of_birth=': true,
        date_of_birth: true,
        save: true
      )
    end

    let(:model) do
      double(
        :model,
        save: true,
        nested_model: nested_model
      )
    end

    context 'when the date has all 3 parts' do
      context 'and the date is valid' do
        let(:params) do
          {
            date_of_birth_day: 25,
            date_of_birth_month: 12,
            date_of_birth_year: 2000
          }
        end

        it 'sets the date on the model specified in the :on option' do
          form.validate(params) && form.save

          expect(nested_model).to have_received(:date_of_birth=).with(Date.new(2000, 12, 25))
        end

        it 'does not add errors to the form' do
          form.validate(params) && form.save

          expect(form.errors.full_messages).to be_blank
        end
      end

      context 'when the date is invalid' do
        let(:params) do
          {
            date_of_birth_month: 14,
            date_of_birth_year: 2000
          }
        end

        it 'does not set the date on the model' do
          form.validate(params) && form.save

          expect(nested_model).not_to have_received(:date_of_birth=)
        end

        it 'adds an error to the form' do
          form.validate(params) && form.save

          expect(form.errors.full_messages).to eq ['Date of birth is not a valid date']
        end
      end
    end

    context 'when the date does not have all 3 parts' do
      let(:params) do
        {
          date_of_birth_year: 2000
        }
      end

      it 'does not set the date on the model' do
        form.validate(params) && form.save

        expect(nested_model).not_to have_received(:date_of_birth=)
      end

      it 'adds an error to the form' do
        form.validate(params) && form.save

        expect(form.errors.full_messages).to eq ['Date of birth is not a valid date']
      end
    end
  end

  context 'when :validate_if option is given' do
    let(:form) { DummyFormWithValidateIfOption.new(model) }
    let(:model) do
      double(
        :model,
        'date_of_birth=': true,
        date_of_birth: true,
        'date_of_marriage=': true,
        date_of_marriage: true,
        save: true
      )
    end

    context 'when the date is valid' do
      let(:params) do
        {
          date_of_birth_day: 25,
          date_of_birth_month: 12,
          date_of_birth_year: 1990,
          date_of_marriage_day: 1,
          date_of_marriage_month: 5,
          date_of_marriage_year: 2015
        }
      end

      it 'sets the date on the model' do
        form.validate(params) && form.save

        expect(model).to have_received(:date_of_birth=).with(Date.new(1990, 12, 25))
        expect(model).to have_received(:date_of_marriage=).with(Date.new(2015, 5, 1))
      end

      it 'does not add errors to the form' do
        form.validate(params) && form.save

        expect(form.errors.full_messages).to be_blank
      end
    end

    context 'when the date is invalid' do
      let(:params) do
        {
          date_of_birth_day: 25,
          date_of_birth_month: 14,
          date_of_birth_year: 1990,
          date_of_marriage_day: 40,
          date_of_marriage_month: 5,
          date_of_marriage_year: 2015
        }
      end

      context 'when the method passed in with the :validate_if returns true' do
        it 'does not set the date on the model' do
          form.validate(params) && form.save

          expect(model).not_to have_received(:date_of_birth=)
        end

        it 'adds an error to the form' do
          form.validate(params) && form.save

          expect(form.errors.full_messages).to include('Date of birth is not a valid date')
        end
      end

      context 'when the method passed in with the :validate_if returns false' do
        it 'does not set the date on the model' do
          form.validate(params) && form.save

          expect(model).not_to have_received(:date_of_marriage=)
        end

        it 'does not add an error to the form' do
          form.validate(params) && form.save

          expect(form.errors.full_messages).not_to include('Date of marriage is not a valid date')
        end
      end
    end
  end
end

class DummyForm < Reform::Form
  include MultiPartDate

  multi_part_date :date_of_birth
end

class DummyFormWithAsOption < Reform::Form
  include MultiPartDate

  multi_part_date :date_of_birth, as: :birth
end

class DummyFormWithDiscardOption < Reform::Form
  include MultiPartDate

  multi_part_date :date_of_birth, discard_day: true
end

class DummyFormWithOnOption < Reform::Form
  include MultiPartDate
  include Composition

  def initialize(first_model)
    super(
      first_model: first_model,
      nested_model: first_model.nested_model
    )
  end

  multi_part_date :date_of_birth, on: :nested_model
end

class DummyFormWithValidateIfOption < Reform::Form
  include MultiPartDate

  multi_part_date :date_of_birth, validate_if: :some_truthy_method
  multi_part_date :date_of_marriage, validate_if: :some_falsy_method

  def some_truthy_method
    true
  end

  def some_falsy_method
    false
  end
end
