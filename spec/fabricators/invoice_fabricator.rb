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
Fabricator(:invoice) do
  transient :account
  transient :user

  invoiceable_id         ''
  invoiceable_type       'MyString'
  payments               ''
  links                  ''
  updated_accounts_at    '2024-11-11 01:29:44'
  invoice_number         'MyString'
  status                 1
  issued_at              '2024-11-11 01:29:44'
  due_at                 '2024-11-11 01:29:44'
  paid_at                '2024-11-11 01:29:44'
  amount                 '9.99'
  due_amount             '9.99'
  currency_code          'MyString'
  notes                  'MyText'
end
