# frozen_string_literal: true

require 'password_generator'

RSpec.describe PasswordGenerator do
  it "has a version number" do
    expect(PasswordGenerator::VERSION).not_to be nil
  end

  describe ".generate" do
    subject(:generate_password) { described_class.generate(length:, uppercase:, lowercase:, number:, special:) }

    let(:length) { 8 }
    let(:uppercase) { true }
    let(:lowercase) { true }
    let(:number) { 0 }
    let(:special) { 0 }

    it "generates password in given length" do
      expect(generate_password.size).to eq(length)
    end
  end
end
