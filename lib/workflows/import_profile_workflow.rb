# frozen_string_literal: true

# From :invoice_account set as a parameter on Context.call with:
# - :email
# - :display_name
# - :given_name
# - :family_name
# - :type
class ImportProfileWorkflow
  include Interactor
end
