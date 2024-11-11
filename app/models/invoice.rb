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
  belongs_to :invoiceable, polymorphic: true
end
