# frozen_string_literal: true

require 'password_generator'

RSpec.describe PasswordGenerator do
  it "has a version number" do
    expect(PasswordGenerator::VERSION).not_to be nil
  end

  shared_examples "InvalidOption" do
    it "raises InvalidOption error" do
      expect { subject }.to raise_error(PasswordGenerator::InvalidOption)
    end
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

    describe "option validation" do
      context "when length is not an integer" do
        let(:length) { "A" }

        it_behaves_like "InvalidOption"
      end

      context "when uppercase is not a boolean" do
        let(:uppercase) { "A" }

        it_behaves_like "InvalidOption"
      end

      context "when lowercase is not a boolean" do
        let(:lowercase) { "A" }

        it_behaves_like "InvalidOption"
      end

      context "when number is not an integer" do
        let(:number) { "A" }

        it_behaves_like "InvalidOption"
      end

      context "when special is not an integer" do
        let(:special) { "A" }

        it_behaves_like "InvalidOption"
      end
    end
  end
end
