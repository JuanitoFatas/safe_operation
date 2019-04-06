require "spec_helper"

RSpec.describe SafeOperation do
  context ".run" do
    class RecordNotFound < StandardError; end
    class User def self.find(id); new; end; end;
    class Guest; end
    class Admin; def initialize(user); end; end
    class SuperAdmin; def initialize(admin); end; end

    def success_op
      @_success_op ||= SafeOperation.run { User.find(42) }
    end

    def failed_op
      @_failed_op ||= SafeOperation.run { raise(RecordNotFound) }
    end

    it "successful operation" do
      expect(success_op.success?).to eq true
      expect(success_op.value).to be_a User
    end

    it "failed operation" do
      expect(failed_op.success?).to eq false
      expect(failed_op.value).to be_a RecordNotFound
    end

    it "value_or when succeeded" do
      actual = success_op.value_or(Guest.new)

      expect(actual).to be_a User
    end

    it "value_or when failed" do
      actual = failed_op.value_or(Guest.new)

      expect(actual).to be_a Guest
    end

    it "value_or_else when succeeded" do
      actual = success_op.value_or_else do |exception|
        if exception.is_a?(RecordNotFound)
          Guest.new
        else
          # logging, re-raise, etc.
        end
      end

      expect(actual).to be_a User
    end

    it "value_or_else to handle exception when failed" do
      actual = failed_op.value_or_else do |exception|
        if exception.is_a?(RecordNotFound)
          Guest.new
        else
          # logging, re-raise, etc.
        end
      end

      expect(actual).to be_a Guest
    end

    it "and_then + or_else when succeeded" do
      actual = success_op.
                 and_then { |user| Admin.new(user) }.
                 or_else { Guest.new }

      expect(actual.value).to be_a Admin
    end

    it "or_else + and_then when succeeded" do
      actual = success_op.
                 or_else { Guest.new }.
                 and_then { |user| Admin.new(user) }

      expect(actual.value).to be_a Admin
    end

    it "and_then chains + or_else when succeeded" do
      actual = success_op.
                 and_then { |user| Admin.new(user) }.
                 and_then { |admin| SuperAdmin.new(admin) }.
                 or_else { Guest.new }

      expect(actual.value).to be_a SuperAdmin
    end

    it "and_then chains + or_else when succeeded" do
      actual = success_op.
                 or_else { Guest.new }.
                 and_then { |user| Admin.new(user) }.
                 and_then { |admin| SuperAdmin.new(admin) }

      expect(actual.value).to be_a SuperAdmin
    end

    it "and_then + or_else when failed" do
      actual = failed_op.
                 and_then { |user| Admin.new(user) }.
                 or_else { Guest.new }

      expect(actual.value).to be_a Guest
    end

    it "or_else + and_then when failed" do
      actual = failed_op.
                 or_else { Guest.new }.
                 and_then { |user| Admin.new(user) }

      expect(actual.value).to be_a Guest
    end
  end
end
