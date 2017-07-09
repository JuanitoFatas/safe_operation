module SafeOperation
  class Failure
    def initialize(failure)
      @failure = failure
    end

    def result
      failure
    end

    def success?
      false
    end

    private
    attr_reader :failure
  end
end
