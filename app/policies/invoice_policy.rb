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
    return true if user.admin?
    # These seem terrible... Figure out a way to measure the
    # performance of this access control check. It might need
    # a refactor to come up  with an ad-hoc query to rule all
    # the access control via rolify problems 🤔
    return true if record.invoiceable == user
    return true if current_account_is?(:customer)
    return true if user.has_role?(:customer, record)
    return true if user.has_role?(:contact, record)

    false
  end

  def current_account_is?(role)
    return false unless Current.account.present?

    Current.account.has_role?(role, record)
  end

  class Scope < Scope
    def resolve
      # TODO: Figure out active query to filter against accounts_users
      #   and rolify tables for the invoices having :customer role
      #   against accounts accessible to this user (see :accessible_to_user?)
      if user.admin?
        scope.all
      else
        scope
          .where(
            invoiceable: Account
              .includes(:members)
              .where(members: { id: user.id })
          )
          .or(
            scope
              .where(invoiceable: user)
          )
      end
    end
  end
end
