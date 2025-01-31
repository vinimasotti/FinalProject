# app/validators/password_complexity_validator.rb
class PasswordComplexityValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /^(?=.*[A-Z])(?=.*[\W]).{8,}$/
        record.errors.add(attribute, (options[:message] || "must include at least one uppercase letter and one symbol"))
      end
    end
  end