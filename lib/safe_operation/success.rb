module SafeOperation
  class Success
    def initialize(success)
      @success = success
    end

    def result
      success
    end

    def success?
      true
    end

    private
    attr_reader :success
  end
end
