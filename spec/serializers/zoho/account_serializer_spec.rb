# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Zoho::AccountSerializer do
  let(:display_name) { Faker::Company.name }
  let(:email) { Faker::Internet.email }
  let(:account) { Fabricate(:account, display_name:, email:) }

  subject { described_class.new(account).serializable_hash }

  it do
    expect(subject).to \
      eq(
        {
          Email: email,
          Company: display_name
        }
      )
  end
end
