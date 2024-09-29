# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Struct::NavbarItem, type: :struct do
  let(:expected_members) { %i[admin enabled feature_flag label new_tab new_window path public section url] }

  it 'has attributes for admin, label, path, enabled, and public' do
    expect(described_class.members).to match_array expected_members
  end
end
