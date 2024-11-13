# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  id                  :uuid             not null, primary key
#  amount              :decimal(10, 2)
#  currency_code       :string
#  due_amount          :decimal(10, 2)
#  due_at              :datetime
#  invoice_number      :string
#  invoiceable_type    :string
#  issued_at           :datetime
#  links               :jsonb
#  notes               :text
#  paid_at             :datetime
#  payments            :jsonb
#  status              :integer
#  updated_accounts_at :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  invoiceable_id      :uuid
#
# Indexes
#
#  index_invoices_on_invoiceable                          (invoiceable_type,invoiceable_id)
#  index_invoices_on_invoiceable_type_and_invoiceable_id  (invoiceable_type,invoiceable_id)
#
class Invoice < ApplicationRecord
  resourcify

  has_many :roles, as: :resource, dependent: :destroy

  # TODO: Add validation to only allow 1 account per invoice
  # belongs_to :account, lambda { |resource|
  #   where('roles.name = ?', 'customer')
  #     .where(roles: { resource: })
  # }, polymorphic: true, class_name: 'Account', source_type: 'Account'

  belongs_to :invoiceable, polymorphic: true

  # belongs_to :customer, lambda { |_y|
  #   where('roles.name = ?', 'customer')
  # }, through: :roles, source: :resource, class_name: 'Account', source_type: 'Account'
  #
  # has_and_belongs_to_many :contacts, lambda { |_x|
  #   where('roles.name = ?', 'contact')
  # }, class_name: 'User', through: :roles, source: :resource, source_type: 'User'
end
