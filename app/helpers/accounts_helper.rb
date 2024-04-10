# frozen_string_literal: true

module AccountsHelper
  include UserProfileHelper

  def account_summary_template
    return 'account-summary-card' if Flipper.enabled?(:feat__account_summary_card, current_user)

    'account-summary'
  end

  def account_status(account)
    case account.status
    when 'active'
      {
        label: 'Active',
        class: 'bg-green-500'
      }
    when 'inactive'
      {
        label: 'Inactive',
        class: 'bg-red-500'
      }
    else
      {
        label: 'Unknown',
        class: 'bg-gray-500'
      }
    end
  end
end
