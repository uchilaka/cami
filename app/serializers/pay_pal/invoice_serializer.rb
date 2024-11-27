# frozen_string_literal: true

module PayPal
  class InvoiceSerializer < AdhocSerializer
    def attributes
      {
        vendor_record_id:,
        vendor_recurring_group_id:,
        invoice_number:,
        vendor_id:,
        payment_vendor:,
        status:,
        invoicer:,
        accounts:,
        viewed_by_recipient:,
        invoiced_at:,
        due_at:,
        currency_code:,
        amount:,
        due_amount:,
        payments:,
        note:,
        links:
      }
    end

    def status
      object['status']
    end

    def vendor_record_id
      object['id']
    end

    def vendor_id
      vendor.id
    end

    def vendor_recurring_group_id
      object['recurring_Id']
    end

    def invoice_number
      object.dig('detail', 'invoice_number')
    end

    def invoicer
      object['invoicer']&.symbolize_keys
    end

    def payment_vendor
      object['payment_vendor'] || 'paypal'
    end

    def amount
      serialize(object['amount'], to: 'Amount')
    end

    def due_amount
      serialize(object['due_amount'], to: 'Amount')
    end

    def payments
      paid_amount = object.dig('payments', 'paid_amount')
      return [] if paid_amount.blank?

      [serialize(paid_amount, to: 'Amount')]
    end

    def links
      object['links']
    end

    def invoiced_at
      object.dig('detail', 'invoice_date')
    end

    def due_at
      object.dig('detail', 'payment_term', 'due_date')
    end

    def viewed_by_recipient
      object.dig('detail', 'viewed_by_recipient')
    end

    def currency_code
      object.dig('detail', 'currency_code')
    end

    def note
      object.dig('detail', 'note')
    end

    def accounts
      primary_recipients.map { |recipient| serialize(recipient, to: 'InvoiceAccount') }
    end

    private

    def vendor
      @vendor ||= Business.find_by(slug: payment_vendor)
    end

    def primary_recipients
      object['primary_recipients'] || []
    end
  end
end
