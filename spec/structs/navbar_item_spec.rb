# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Struct::NavbarItem, type: :struct do
  it 'has attributes for admin, label, path, enabled, and public' do
    expect(described_class.members).to match_array %i[admin enabled feature_flag label path public section url]
  end
end
