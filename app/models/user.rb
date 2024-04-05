# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  family_name            :string
#  given_name             :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  alias_attribute :first_name, :given_name
  alias_attribute :last_name, :family_name

  # Doc on name_of_person gem: https://github.com/basecamp/name_of_person
  has_person_name

  after_create_commit :initialize_profile

  def profile
    @profile ||= UserProfile.find_by(user_id: id)
  end

  private

  def initialize_profile
    UserProfile.create(user_id: id)
  end
end
