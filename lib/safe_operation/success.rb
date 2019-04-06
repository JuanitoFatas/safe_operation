class SafeOperation
  class Success
    def initialize(success)
      @success = success
    end

    def value
      @success
    end

    def success?
      true
    end
  end
end
