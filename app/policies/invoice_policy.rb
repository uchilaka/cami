# frozen_string_literal: true

class InvoicePolicy < ApplicationPolicy
  def index?
    user.admin? || accessible_to_user?
  end

  def show?
    user.admin? || accessible_to_user?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? || accessible_to_user?
  end

  def destroy?
    user.admin? || accessible_to_user?
  end

  def accessible_to_user?
    user.admin? || current_account_is?(:customer)
  end

  def current_account_is?(role)
    return false unless Current.account.present?

    Current.account.has_role?(role)
  end

  class Scope < Scope
    def resolve
      # TODO: Figure out active query to filter against accounts_users
      #   and rolify tables for the invoices having :customer role
      #   against accounts accessible to this user
      scope.all
    end
  end
end
