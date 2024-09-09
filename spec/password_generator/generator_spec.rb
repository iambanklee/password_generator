# frozen_string_literal: true

require_relative "../../lib/password_generator/generator"

RSpec.describe PasswordGenerator::Generator do
  let(:generator_instance) { described_class.new(length:, uppercase:, lowercase:, number:, special:) }

  let(:length) { 8 }
  let(:uppercase) { true }
  let(:lowercase) { true }
  let(:number) { 0 }
  let(:special) { 0 }

  describe "#run" do
    shared_examples "generate_password" do
      it "generates password in given length" do
        expect(generate_password.size).to eq(length)
      end

      context "when uppercase options is false" do
        let(:uppercase) { false }

        it "generates password does not contains uppercase characters" do
          uppercase_counter = generate_password.scan(/#{PasswordGenerator::UPPERCASE}/).size

          expect(uppercase_counter).to eq(0)
        end
      end

      context "when lowercase options is false" do
        let(:lowercase) { false }

        it "generates password does not contains lowercase characters" do
          lowercase_counter = generate_password.scan(/#{PasswordGenerator::LOWERCASE}/).size

          expect(lowercase_counter).to eq(0)
        end
      end

      context "when number options is given" do
        let(:number) { 2 }

        it "generates password contains exactly given number times" do
          number_counter = generate_password.scan(/#{PasswordGenerator::NUMBER}/).size

          expect(number_counter).to eq(number)
        end
      end

      context "when special options is given" do
        let(:special) { 2 }

        it "generates password contains exactly given special times" do
          special_counter = generate_password.scan(/#{PasswordGenerator::SPECIAL}/).size

          expect(special_counter).to eq(special)
        end
      end
    end

    subject(:generate_password) { generator_instance.run(strategy:) }

    context "with random_position strategy" do
      let(:strategy) { :random_position }

      it_behaves_like "generate_password"
    end

    context "with replacement strategy" do
      let(:strategy) { :replacement }

      it_behaves_like "generate_password"
    end

    context "with shuffle_strategy strategy" do
      let(:strategy) { :shuffle }

      it_behaves_like "generate_password"
    end

    context "with invalid strategy" do
      let(:strategy) { :it_works }
      let(:error_message_regex) { /it_works is an invalid option/ }

      it "raises InvalidOption error" do
        expect { subject }.to raise_error(PasswordGenerator::InvalidOption, error_message_regex)
      end
    end
  end

  describe "parameter validation" do
    shared_examples "InvalidOption" do
      it "raises InvalidOption error" do
        expect { subject }.to raise_error(PasswordGenerator::InvalidOption, error_message_regex)
      end
    end

    subject(:validation) { generator_instance }

    context "when length is not an integer" do
      let(:length) { "A" }
      let(:error_message_regex) { /length must be a valid integer/ }

      it_behaves_like "InvalidOption"
    end

    context "when uppercase is not a boolean" do
      let(:uppercase) { "A" }
      let(:error_message_regex) { /uppercase must be a boolean value/ }

      it_behaves_like "InvalidOption"
    end

    context "when lowercase is not a boolean" do
      let(:lowercase) { "A" }
      let(:error_message_regex) { /lowercase must be a boolean value/ }

      it_behaves_like "InvalidOption"
    end

    context "when number is not an integer" do
      let(:number) { "A" }
      let(:error_message_regex) { /number must be a valid integer/ }

      it_behaves_like "InvalidOption"
    end

    context "when special is not an integer" do
      let(:special) { "A" }
      let(:error_message_regex) { /special must be a valid integer/ }

      it_behaves_like "InvalidOption"
    end

    context "when sum of number and special is more than length" do
      let(:number) { 4 }
      let(:special) { 5 }
      let(:error_message_regex) { /sum of number and special cannot be more than length/ }

      it_behaves_like "InvalidOption"
    end
  end
end
