# frozen_string_literal: true

require_relative "password_generator/version"

module PasswordGenerator
  class Error < StandardError; end
  class InvalidOption < StandardError; end

  UPPERCASE = ("A".."Z").to_a.freeze
  LOWERCASE = ("a".."z").to_a.freeze
  NUMBER = (0..9).to_a.freeze
  SPECIAL = %w[@ % ! ? * ^ &].freeze

  def self.generate(length:, uppercase:, lowercase:, number:, special:)
    password = ""
    errors = []
    bucket = []

    errors << "length must be an integer" unless length.is_a?(Integer)

    if [true, false].include?(uppercase)
      bucket << upper_case_char
    else
      errors << "uppercase must be a boolean value"
    end

    if [true, false].include?(lowercase)
      bucket << lower_case_char
    else
      errors << "lowercase must be a boolean value"
    end

    if number.is_a?(Integer)
      bucket << number_char
    else
      errors << "number must be an integer"
    end

    if special.is_a?(Integer)
      bucket << special_char
    else
      errors << "special must be an integer"
    end

    raise InvalidOption, errors.join(",") unless errors.empty?
    raise InvalidOption, "number + special cannot be more than length" if number + special > length

    (0...length).each do |_|
      password += bucket.sample.call.to_s
    end

    password
  end

  def self.upper_case_char
    -> { UPPERCASE.sample }
  end

  def self.lower_case_char
    -> { UPPERCASE.sample }
  end

  def self.number_char
    -> { NUMBER.sample }
  end

  def self.special_char
    -> { SPECIAL.sample }
  end
end
