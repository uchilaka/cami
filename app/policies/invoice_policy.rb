# frozen_string_literal: true

class InvoicePolicy < ApplicationPolicy
  def index?
    return true if user.admin?

    if Current.account.present?
      is_account_member?
    else
      user.has_role?(:customer) || user.has_role?(:contact)
    end
  end

  def show?
    return true if user.admin?
    return true if user.has_role?(:contact, record)

    update?
  end

  def create?
    user.admin? || user.has_role?(:customer, record)
  end

  def update?
    return true if create?
    return true if record.invoiceable == user
    return true if is_account_member? && current_account_is?(:customer)

    false
  end

  def destroy?
    user.admin? || update?
  end

  def accessible_to_user?
    return true if user.admin?
    # These seem terrible... Figure out a way to measure the
    # performance of this access control check. It might need
    # a refactor to come up  with an ad-hoc query to rule all
    # the access control via rolify problems 🤔
    return true if record.invoiceable == user
    return true if user.has_role?(:customer, record)
    return true if user.has_role?(:contact, record)
    return true if current_account_is?(:customer)

    false
  end

  def is_account_member?
    return false unless Current.account.present?

    Current.account.members.include?(user)
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
