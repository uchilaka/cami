# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  alias_attribute :first_name, :given_name
  alias_attribute :last_name, :family_name

  validates :email, presence: true, uniqueness: true, email: true

  # Doc on name_of_person gem: https://github.com/basecamp/name_of_person
  has_person_name
end
