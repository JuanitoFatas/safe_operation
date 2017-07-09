require "spec_helper"

RSpec.describe SafeOperation do
  it "raises NoFailureHandler when no error handle block specified" do
    expect { SafeOperation.either(1 + 1) }.to raise_error SafeOperation::NoFailureHandler
  end

  describe "#either" do
    class User
      ActiveRecordRecordNotFound = Class.new(StandardError)

      def self.find(id)
        (id == 1) ? new : raise(ActiveRecordRecordNotFound)
      end

      def self.find_by(*); end
    end

    class Guest
    end

    it "return success object when operation succeeded" do
      result = SafeOperation.either(->{ User.find(1) }) { Guest.new }

      expect(result).to be_a SafeOperation::Success
      expect(result).to be_success
      expect(result.result).to be_a User
    end

    it "return failure object when operation raised exception" do
      result = SafeOperation.either(->{ User.find(2) }) { Guest.new }

      expect(result).to be_a SafeOperation::Failure
      expect(result).not_to be_success
      expect(result.result).to be_a Guest
    end

    it "return failure object when operation returned nil" do
      result = SafeOperation.either(->{ User.find_by(id: 42) }) { Guest.new }

      expect(result).to be_a SafeOperation::Failure
      expect(result).not_to be_success
      expect(result.result).to be_a Guest
    end
  end
end
