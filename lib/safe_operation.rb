# frozen_string_literal: true
require "forwardable"

require_relative "safe_operation/version"
require_relative "safe_operation/success"
require_relative "safe_operation/failure"

class SafeOperation
  extend Forwardable

  class << self
    protected(:new)

    def run
      success(yield)
    rescue StandardError => exception
      failure(exception)
    end

    def success(value)
      new(success: value)
    end

    def failure(value)
      new(failure: value)
    end
  end

  def_delegators :@result, :success?, :value

  def initialize(success: nil, failure: nil)
    @result = success ? Success.new(success) : Failure.new(failure)
  end

  def value_or(fallback_value)
    if success?
      value
    else
      fallback_value
    end
  end

  def value_or_else(&fallback_block)
    if success?
      value
    else
      fallback_block.call(value)
    end
  end

  def and_then(&block)
    if success?
      self.class.success(block.call(value))
    else
      self
    end
  end

  def or_else(&block)
    if success?
      self
    else
      self.class.failure(block.call(value))
    end
  end
end
