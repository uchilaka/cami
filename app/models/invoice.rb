# frozen_string_literal: true

class Invoice
  include DocumentRecord
  include Mongoid::Attributes::Dynamic

  embeds_many :accounts, class_name: 'InvoiceAccount'
  embeds_many :payments, class_name: 'InvoiceAmount'

  embeds_one :amount, class_name: 'InvoiceAmount'
  embeds_one :due_amount, class_name: 'InvoiceAmount'

  accepts_nested_attributes_for :accounts, :amount, :due_amount, :payments

  after_initialize :initialize_amounts

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
  field :invoicer, type: Hash # { email_address }
  field :viewed_by_recipient, type: Boolean
  field :invoiced_at, type: Time
  field :due_at, type: Time
  field :updated_accounts_at, type: Time
  field :currency_code, type: String
  field :links, type: Array
  field :note, type: String

  validates :payment_vendor,
            presence: true,
            inclusion: { in: %w[paypal] }

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

  def initialize_amounts
    self.amount ||= InvoiceAmount.new
    self.due_amount ||= InvoiceAmount.new
    self.payments ||= []
  end
end
