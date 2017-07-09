require "spec_helper"

RSpec.describe SafeOperation do
  it "has a version number" do
    expect(SafeOperation::VERSION).not_to be nil
  end
end
