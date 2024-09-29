# frozen_string_literal: true

require 'rails_helper'

# Documentation on ActiveModel matchers:
# https://matchers.shoulda.io/docs/v6.4.0/Shoulda/Matchers/ActiveModel.html
RSpec.describe InvoiceAmount, type: :model do
  it { should be_mongoid_document }
  it { should have_field(:currency_code).of_type(String).with_default_value_of('USD') }
  it { should have_field(:value).of_type(Float).with_default_value_of(0.0) }
  it { should validate_inclusion_of(:currency_code).in_array(%w[USD]) }
  it { should validate_presence_of(:currency_code) }
end
