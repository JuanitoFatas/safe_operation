# frozen_string_literal: true

require_relative "safe_operation/version"
require_relative "safe_operation/success"
require_relative "safe_operation/failure"

module SafeOperation
  NoFailureHandler = Class.new NotImplementedError

  def self.either(maybe_block)
    raise NoFailureHandler if !block_given?

    if maybe = maybe_block.call
      Success.new maybe
    else
      Failure.new yield
    end
  rescue StandardError
    Failure.new yield
  end

  NO_FAILURE_HANDLER_MESSAGE = "Please pass in a block to handle the failure 😅"
  private_constant :NO_FAILURE_HANDLER_MESSAGE
end
