# frozen_string_literal: true

require_relative "password_generator/version"

module PasswordGenerator
  class Error < StandardError; end
  class InvalidOption < StandardError; end

  UPPERCASE = ("A".."Z").to_a.freeze
  LOWERCASE = ("a".."z").to_a.freeze
  NUMBER = (0..9).to_a.freeze
  SPECIAL = %w[@ % ! ? * ^ &]

  def self.generate(length:, uppercase:, lowercase:, number:, special:)
    errors = []

    errors << "length must be an integer" unless length.is_a?(Integer)

    raise InvalidOption.new(errors.join(",")) unless errors.empty?

    bucket = [upper_case_char, lower_case_char, number_char, special_char]
    password = ""

    (0...length).each do |_|
      password += "#{bucket.sample.call}"
    end

    password
  end

  private

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
