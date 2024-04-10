# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :uuid             not null, primary key
#  display_name :string           not null
#  slug         :string
#  status       :integer
#  type         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tax_id       :string
#
require 'rails_helper'

RSpec.describe Account, type: :model do
  subject { Fabricate :account }

  it { should validate_presence_of :display_name }

  describe '#state' do
    it { transition_from(%i[demo guest]).to(:active).on_event(:activate) }
    it { transition_from(%i[active payment_due overdue]).to(:paid).on_event(:enroll) }
    it { transition_from(%i[active payment_due overdue]).to(:suspended).on_event(:suspend) }
    it { transition_from(%i[suspended overdue deactivated]).to(:active).on_event(:reactivate) }
    it { transition_from(%i[payment_due overdue suspended]).to(:deactivated).on_event(:deactivate) }
  end
end
