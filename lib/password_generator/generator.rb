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

    def run(strategy: :random_position)
      case strategy
      when :random_position
        random_position_password
      when :replacement
        replacement_strategy
      when :shuffle
        shuffle_strategy
      end
    end

    def random_position_password
      password = ""

      (0...length).each do |i|
        character_rule = if number_positions.include?(i)
                           number_char
                         elsif special_positions.include?(i)
                           special_char
                         else
                           general_buckets.sample
                         end

        password += character_rule.call.to_s
      end

      password
    end

    def replacement_strategy
      password = ""

      (0...length).each do |_|
        password += general_buckets.sample.call.to_s
      end

      number_positions.each { |i| password[i] = number_char.call.to_s }
      special_positions.each { |i| password[i] = special_char.call.to_s }

      password
    end

    def shuffle_strategy
      password = []

      general_bucket_counter = length - number - special

      number.times { |_| password << number_char.call }
      special.times { |_| password << special_char.call }
      general_bucket_counter.times { |_| password << general_buckets.sample.call }

      password.shuffle.join
    end

    private

    def validate!
      validate_length
      validate_uppercase
      validate_lowercase
      validate_number
      validate_special

      raise InvalidOption, errors.join(",") unless errors.empty?
      raise InvalidOption, "sum of number and special cannot be more than length" if number + special > length
    end

    def validate_special
      @errors << "special must be a valid integer" unless special.is_a?(Integer) && special >= 0
    end

    def validate_number
      @errors << "number must be a valid integer" unless number.is_a?(Integer) && number >= 0
    end

    def validate_lowercase
      @errors << "lowercase must be a boolean value" unless BOOLEAN_VALUES.include?(lowercase)
    end

    def validate_uppercase
      @errors << "uppercase must be a boolean value" unless BOOLEAN_VALUES.include?(uppercase)
    end

    def validate_length
      @errors << "length must be a valid integer" unless length.is_a?(Integer) && length >= 0
    end

    def general_buckets
      return @general_buckets if defined? @general_buckets

      @general_buckets = []
      @general_buckets << upper_case_char if uppercase
      @general_buckets << lower_case_char if lowercase

      @general_buckets
    end

    def number_positions
      return @number_positions if defined? @number_positions

      @number_positions = []
      while @number_positions.length < number
        position = rand(length)
        next if @number_positions.include?(position)

        @number_positions << position
      end

      @number_positions
    end

    def special_positions
      return @special_positions if defined? @special_positions

      @special_positions = []

      while @special_positions.length < special
        position = rand(length)
        next if number_positions.include?(position) || @special_positions.include?(position)

        @special_positions << position
      end

      @special_positions
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
