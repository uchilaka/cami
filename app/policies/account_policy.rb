# frozen_string_literal: true

class AccountPolicy < ApplicationPolicy
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
    record.users.include?(user)
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope
          .includes(:accounts_users)
          .where(accounts_users: { user_id: user.id })
      end
    end
  end
end
