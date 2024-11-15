# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  id                  :uuid             not null, primary key
#  amount_cents        :integer          default(0), not null
#  amount_currency     :string           default("USD"), not null
#  due_amount_cents    :integer          default(0), not null
#  due_amount_currency :string           default("USD"), not null
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

  has_rich_text :notes

  # TODO: Refactor amount fields to *_in_cents
  monetize :amount_cents
  monetize :due_amount_cents

  has_many :roles, as: :resource, dependent: :destroy

  belongs_to :invoiceable, polymorphic: true

  validates :currency_code,
            presence: true,
            inclusion: { in: Money::Currency.all.map(&:iso_code) }
  validates :amount, presence: true

  # TODO: Implement AASM status

  def currency_code
    amount_currency
  end

  def currency_code=(currency_code)
    self.amount_currency ||= currency_code
    self.due_amount_currency ||= currency_code
  end

  def account=(account)
    self.invoiceable = account
  end

  def account
    invoiceable if invoiceable.is_a?(Account)
  end
end
