# frozen_string_literal: true

module Errors
  class AccountConfirmationRequired < StandardError; end
  class ElevatedPrivilegesRequired < StandardError; end
  class Forbidden < StandardError; end
  class ResourceNotFound < StandardError; end
  class Unauthorized < StandardError; end
  class UnprocessableEntity < StandardError; end
  class InternalServerError < StandardError; end
  class Unsupported < StandardError; end
end
