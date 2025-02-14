# frozen_string_literal: true

module AccountsHelper
  include UsersHelper

  def account_search_enabled?
    Flipper.enabled?(:feat__account_search, current_user)
  end

  def account_filtering_enabled?
    Flipper.enabled?(:feat__account_filtering, current_user)
  end

  def modal_dom_id(resource, content_type: '')
    "#{resource.class.table_name.singularize}--#{content_type}-modal"
  end

  def model_actions(resource)
    resource_name = resource.class.name.to_s || 'resource'
    {
      edit: {
        dom_id: SecureRandom.uuid,
        http_method: 'GET',
        label: 'Edit',
        url: account_url(resource)
      },
      delete: {
        dom_id: SecureRandom.uuid,
        http_method: 'DELETE',
        label: 'Delete',
        url: account_url(resource, format: :json)
      },
      # TODO: I think this should be back(?)
      show: {
        dom_id: SecureRandom.uuid,
        http_method: 'GET',
        label: "Back to #{resource_name.pluralize}",
        url: accounts_url
      }
      # ,transactions_index: {
      #   dom_id: SecureRandom.uuid,
      #   http_method: 'GET',
      #   label: 'Transactions',
      #   url: account_invoices_url(resource)
      # },
    }
  end

  def segment_filter_options
    [
      ['Past due', 'past_due'],
      ['In active service', 'in_service'],
      # Accounts that are NOT in active service, but are in good standing
      # i.e. have at least 1 paid invoice and aren't past due
      %w[Prospects prospects],
      %w[Closed closed],
    ]
  end

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

  def account_status_options
    Account.defined_enums['status'].map do |status, _|
      [status.titleize, status]
    end
  end
end
