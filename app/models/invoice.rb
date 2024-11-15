# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  id                        :uuid             not null, primary key
#  amount_cents              :integer          default(0), not null
#  amount_currency           :string           default("USD"), not null
#  due_amount_cents          :integer          default(0), not null
#  due_amount_currency       :string           default("USD"), not null
#  due_at                    :datetime
#  invoice_number            :string
#  invoiceable_type          :string
#  issued_at                 :datetime
#  links                     :jsonb
#  notes                     :text
#  paid_at                   :datetime
#  payment_vendor            :string
#  payments                  :jsonb
#  status                    :integer
#  updated_accounts_at       :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  invoiceable_id            :uuid
#  vendor_record_id          :string
#  vendor_recurring_group_id :string
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

  PAYPAL_BASE_URL = ENV.fetch('PAYPAL_BASE_URL', Rails.application.credentials.paypal&.base_url).freeze

  has_many :roles, as: :resource, dependent: :destroy

  belongs_to :invoiceable, polymorphic: true

  validates :payment_vendor,
            presence: true,
            inclusion: { in: %w[paypal] }
  validates :amount_currency,
            allow_nil: true,
            inclusion: { in: Money::Currency.all.map(&:iso_code) }
  validates :due_amount_currency,
            allow_nil: true,
            inclusion: { in: Money::Currency.all.map(&:iso_code) }
  validates :amount_cents, presence: true
  # validates :due_amount_cents, presence: true

  # TODO: Implement AASM status

  def payment_vendor_url
    case payment_vendor
    when 'paypal'
      "#{PAYPAL_BASE_URL}/invoice/s/details/#{vendor_record_id}"
    else
      ''
    end
  end

  # @deprecated Use `amount_currency` or `due_amount_currency` instead
  def currency_code
    amount_currency
  end

  # @deprecated Use assignment to `amount_currency` or `due_amount_currency` instead
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
