# frozen_string_literal: true

module PasswordGenerator
  class InvalidOption < StandardError; end

  UPPERCASE = ("A".."Z").to_a.freeze
  LOWERCASE = ("a".."z").to_a.freeze
  NUMBER = (0..9).to_a.freeze
  SPECIAL = %w[@ % ! ? * ^ &].freeze

  class Generator
    BOOLEAN_VALUES = [true, false].freeze

    attr_reader :length, :uppercase, :lowercase, :number, :special,
                :errors

    def initialize(length:, uppercase:, lowercase:, number:, special:)
      @length = length
      @uppercase = uppercase
      @lowercase = lowercase
      @number = number
      @special = special

      @errors = []

      validate!
    end

    def run
      password = ""
      general_bucket = []

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

    private

    def validate!
      @errors << "length must be a valid integer" unless length.is_a?(Integer) && length >= 0
      @errors << "uppercase must be a boolean value" unless BOOLEAN_VALUES.include?(uppercase)
      @errors << "lowercase must be a boolean value" unless BOOLEAN_VALUES.include?(lowercase)
      @errors << "number must be a valid integer" unless number.is_a?(Integer) && number >= 0
      @errors << "special must be a valid integer" unless special.is_a?(Integer) && special >= 0

      raise InvalidOption, errors.join(",") unless errors.empty?
      raise InvalidOption, "sum of number and special cannot be more than length" if number + special > length
    end

    def upper_case_char
      -> { UPPERCASE.sample }
    end

    def lower_case_char
      -> { LOWERCASE.sample }
    end

    def number_char
      -> { NUMBER.sample }
    end

    def special_char
      -> { SPECIAL.sample }
    end
  end
end
