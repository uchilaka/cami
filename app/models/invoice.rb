# frozen_string_literal: true

class Invoice
  include DocumentRecord
  include Mongoid::Attributes::Dynamic

  after_create :initialize_record!

  # TODO: Consider making :record_id required before saving any invoice document
  field :record_id, type: String
  field :vendor_record_id, type: String
  field :vendor_recurring_group_id, type: String
  field :invoice_number, type: String
  field :payment_vendor, type: String
  # Payment vendor documentation for invoice status:
  # https://developer.paypal.com/docs/api/invoicing/v2/#definition-invoice_status
  field :status, type: String
  # { email_address }
  field :invoicer, type: Hash
  field :accounts, type: Array
  field :viewed_by_recipient, type: Boolean
  field :invoiced_at, type: Time
  field :due_at, type: Time
  field :updated_accounts_at, type: Time
  field :currency_code, type: String
  # { currency_code, value }
  field :amount, type: Hash
  # { currency_code, value }
  field :due_amount, type: Hash
  # { payments: { paid_amount: { currency_code, value } } }
  field :payments, type: Hash
  field :links, type: Array
  field :note, type: String

  validates :payment_vendor,
            presence: true,
            inclusion: { in: %w[paypal] }

  before_validation :convert_amount, on: %i[create update], if: -> { amount.present? }
  before_validation :convert_due_amount, on: %i[create update], if: -> { due_amount.present? }
  before_validation :convert_payments, on: %i[create update], if: -> { payments.present? }

  before_create :initialize_amount, if: -> { amount.blank? }

  PAYPAL_BASE_URL = ENV.fetch('PAYPAL_BASE_URL', Rails.application.credentials.paypal&.base_url).freeze

  def payment_vendor_url
    "#{PAYPAL_BASE_URL}/invoice/s/details/#{vendor_record_id}"
  end

  def record
    InvoiceRecord.find_by(id: record_id)
  end

  def recurring?
    vendor_recurring_group_id.present?
  end

  def initialize_record!
    return if record_id.present? && InvoiceRecord.exists?(id: record_id)

    record = InvoiceRecord.find_or_create_by!(document_id: id.to_s)
    update!(record_id: record.id)
  end

  private

  def convert_amount
    self.amount = Amount.new(amount).to_h
  end

  def convert_due_amount
    self.due_amount = Amount.new(due_amount).to_h
  end

  def convert_payments
    return unless payments.is_a?(Hash)

    self.payments = {
      paid_amount: Amount.new(payments[:paid_amount]).to_h
    }
  end

  def initialize_amount
    self.amount ||= { currency_code: 'USD', value: 0.0 }
  end
end
