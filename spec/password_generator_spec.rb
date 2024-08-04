# frozen_string_literal: true

require_relative '../lib/password_generator'
require_relative '../lib/password_generator/generator'

RSpec.describe PasswordGenerator do
  it "has a version number" do
    expect(PasswordGenerator::VERSION).not_to be nil
  end

  describe "self.run" do
    subject(:run) { PasswordGenerator.run(length:, uppercase:, lowercase:, number:, special:) }

    let(:length) { 8 }
    let(:uppercase) { true }
    let(:lowercase) { true }
    let(:number) { 0 }
    let(:special) { 0 }
    let(:mock_generator) { instance_double("Generator", run: true) }

    before do
      allow(PasswordGenerator::Generator).to receive(:new).and_return(mock_generator)
    end

    it "calls generator#run" do
      run

      expect(mock_generator).to have_received(:run)
    end
  end
end
