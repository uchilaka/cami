# frozen_string_literal: true

# == Schema Information
#
# Table name: allowlisted_jwts
#
#  id       :uuid             not null, primary key
#  aud      :string
#  exp      :datetime         not null
#  jti      :string           not null
#  users_id :uuid             not null
#
# Indexes
#
#  index_allowlisted_jwts_on_jti       (jti) UNIQUE
#  index_allowlisted_jwts_on_users_id  (users_id)
#
# Foreign Keys
#
#  fk_rails_...  (users_id => users.id) ON DELETE => cascade
#
class AllowlistedJwt < ApplicationRecord
end
