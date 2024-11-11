# frozen_string_literal: true

module MaybeAccountSpecific
  extend ActiveSupport::Concern

  included do
    raise LarCity::MissingRequiredModule, "#{name} requires LarCity::CurrentAttributes" \
      unless include?(LarCity::CurrentAttributes)
  end

  module ClassMethods
    def load_account(actions, options = {})
      if actions.is_a?(Array)
        [*actions].each { |action| authorized_actions[action] = options }
      elsif actions == :all
        %i[index show new edit create update destroy].each { |action| authorized_actions[action] = options }
      end

      before_action :set_account, only: authorized_actions.keys
    end

    def authorized_actions
      @authorized_actions ||= {}.with_indifferent_access
    end
  end

  attr_reader :account

  def set_account
    opts = action_options(self.class.authorized_actions[action_name])
    return unless (account_id = params[:account_id]).present?

    @account =
      if opts[:optional]
        Account.find_by(id: account_id)
      else
        Account.find(account_id)
      end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to invoices_path, notice: 'Account not found' }
      format.json { render json: { error: 'Account not found' }, status: :not_found }
    end
  ensure
    Current.account ||= @account
  end

  private

  def action_options(opts = {})
    opts.reverse_merge!(optional: true, bounce_to: :root_path)
    opts[:bounce_to] = send(opts[:bounce_to]) if respond_to?(opts[:bounce_to])
    opts
  end
end
