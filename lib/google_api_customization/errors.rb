module GoogleApiCustomization
  class Error < StandardError
    attr_reader :response
    def initialize(response)
      @response = response
      super(response.parsed_response.to_s)
    end
  end

  class OverQueryLimitError  < Error; end
  class RequestDeniedError   < Error; end
  class InvalidRequestError  < Error; end
  class UnknownError         < Error; end
  class NotFoundError        < Error; end
  class RetryError           < Error; end
  class RetryTimeoutError    < Error; end
end
