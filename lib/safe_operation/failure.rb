class SafeOperation
  class Failure
    def initialize(failure)
      @failure = failure
    end

    def value
      @failure
    end

    def success?
      false
    end
  end
end
