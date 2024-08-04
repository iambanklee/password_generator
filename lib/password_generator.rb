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
    general_bucket = []

    errors << "length must be an integer" unless length.is_a?(Integer)
    errors << "uppercase must be a boolean value" unless [true, false].include?(uppercase)
    errors << "lowercase must be a boolean value" unless [true, false].include?(lowercase)
    errors << "number must be an integer" unless number.is_a?(Integer)
    errors << "special must be an integer" unless special.is_a?(Integer)

    raise InvalidOption, errors.join(",") unless errors.empty?
    raise InvalidOption, "number + special cannot be more than length" if number + special > length

    general_bucket << upper_case_char if uppercase
    general_bucket << lower_case_char if lowercase

    number_position = []
    special_position = []

    while number_position.length < number
      position = rand(length)
      next if number_position.include?(position)

      number_position << position
    end

    while special_position.length < special
      position = rand(length)

      next if number_position.include?(position) || special_position.include?(position)

      special_position << position
    end

    (0...length).each do |i|
      character_rule = if number_position.include?(i)
                         number_char
                       elsif special_position.include?(i)
                         special_char
                       else
                         general_bucket.sample
                       end

      password += character_rule.call.to_s
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
