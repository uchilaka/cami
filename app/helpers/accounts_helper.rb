# frozen_string_literal: true

module AccountsHelper
  def account_summary_template
    return 'account-summary-card' if Flipper.enabled?(:feat__account_summary_card, current_user)

    'account-summary'
  end
end
