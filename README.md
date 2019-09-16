<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Purpose](#purpose)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Available options](#available-options)
  - [Generate inputs with a different name base:](#generate-inputs-with-a-different-name-base)
  - [To omit parts, set the appropriate option below to `true`:](#to-omit-parts-set-the-appropriate-option-below-to-true)
  - [Validate conditionally:](#validate-conditionally)
  - [These options are delegated to reform's `property` method:](#these-options-are-delegated-to-reforms-property-method)
- [View example](#view-example)
- [Contributing](#contributing)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Purpose

Easy implementation of multiple date part fields on the form object level.

Conceptually it works very similar to Rails date_select helper, e.g. breaks up date month, day and year into separate inputs on the front-end, while parsing to one model attribute on the back-end.

The difference is 1) It allows you to style date part inputs however you want and 2) This is an extension to [reform gem](https://github.com/apotonick/reform) and works on form object level.

# Getting Started

```ruby
gem 'multi_part_date'
```

Or install it yourself as:

    $ gem install multi_part_date

# Usage

Form object:

```ruby
class BasicForm < Reform::Form
  multi_part_date :date_of_birth
end
```

Where `date_of_birth` is an actual model attribute.

# Available options

## Generate inputs with a different name base:

```
as: :birth
```

Will generate inputs

```
f.birth_day
f.birth_month
f.birth_year
```

## To omit parts, set the appropriate option below to `true`:

```
:discard_day
:discard_month
:discard_year
```

## Validate conditionally:

```
validate_if: :some_method
```

The above method needs to be defined in the form object.
Note that date is validated by default.
This gem uses `Date.valid_date?` to determine if the date is valid.

## These options are delegated to reform's `property` method:

```
:on
:type
```

# View example
(using simple_form here & written in slim)

```slim
simple_form_for @basic_form do |f|

  = f.input :birth_month

  = f.input :birth_day

  = f.input :birth_year
```

# Contributing

Bug reports and pull requests are welcome! :smile: Fork the repo and submit your PR or issue.

# License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
