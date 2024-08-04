# frozen_string_literal: true

require_relative "password_generator/version"
require_relative "password_generator/generator"

module PasswordGenerator
  class Error < StandardError; end

  def self.run(length:, uppercase:, lowercase:, number:, special:)
    Generator.new(length:, uppercase:, lowercase:, number:, special:).run
  end
end
