# frozen_string_literal: true

class AccountsRole < ApplicationRecord
  belongs_to :account
  belongs_to :role
end
