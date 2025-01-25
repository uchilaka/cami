# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :uuid             not null, primary key
#  display_name :string
#  email        :string
#  metadata     :jsonb
#  phone        :jsonb
#  readme       :text
#  slug         :string
#  status       :integer
#  type         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tax_id       :string
#
class Account < ApplicationRecord
  rolify
  resourcify

  include AASM

  # There are security implications to consider when using deterministic encryption.
  # See https://guides.rubyonrails.org/active_record_encryption.html#deterministic-and-non-deterministic-encryption
  encrypts :tax_id, deterministic: true

  has_rich_text :readme

  attribute :type, :string, default: 'Account'
  attribute :slug, :string, default: -> { SecureRandom.alphanumeric(4).downcase }
  attribute :metadata, :jsonb, default: { contacts: [] }

  validates :display_name, presence: true
  validates :email, email: true, allow_nil: true
  validates :type, presence: true, inclusion: { in: %w[Account Business Individual Government Nonprofit] }
  validates :slug, presence: true, uniqueness: { case_sensitive: false }
  validates :tax_id, uniqueness: { case_sensitive: false }, allow_blank: true, allow_nil: true

  has_many :invoices, as: :invoiceable, dependent: :nullify
  # TODO: This generates the following console error:
  #   `warning: already initialized constant Account::HABTM_Roles`
  #   However, without this line, the behavior of assigning
  #   roles to accounts on invoices breaks.
  has_and_belongs_to_many :roles, inverse_of: :accounts, dependent: :destroy
  has_and_belongs_to_many :members, class_name: 'User', join_table: 'accounts_users'

  # @deprecated use the direct "members" relationship instead. I guess we're
  #   going to learn interesting things about aliasing associations in Rails 😅
  alias users members

  before_validation :format_tax_id, if: :tax_id_changed?

  has_rich_text :readme

  def assign_default_role
    add_role(:owner, Current.user) unless Current.user.nil? || Current.user.admin?
  end

  def primary_users_confirmed?
    # TODO: Check that all primary users have confirmed their email addresses
    true
  end

  enum :status, {
    demo: 1,
    draft: 2,
    guest: 5,
    active: 10,
    paid: 20,
    payment_due: 25,
    overdue: 30,
    suspended: 35,
    deactivated: 40
  }, scopes: true

  aasm column: :status, enum: true, logger: Rails.logger do
    state :draft, initial: true
    state :demo
    state :guest
    state :active
    state :paid
    state :payment_due
    state :overdue
    state :suspended
    state :deactivated

    event :invite do
      transitions from: %i[demo], to: :guest
    end

    # TODO: Figure out how to designate primary users
    # TODO: Ensure that all primary users are guided to confirm their email addresses
    #   as soon as their accounts are created so service can be activated
    event :activate do
      transitions from: %i[demo guest], to: :active, guard: :primary_users_confirmed?
    end

    event :enroll do
      transitions from: %i[active payment_due overdue], to: :paid
    end

    event :invoice do
      transitions from: %i[active paid], to: :payment_due
    end

    # NOTE: Account suspension happens after the user has failed to pay an invoice or subscription
    #   and the overdue period has passed
    event :suspend do
      transitions from: %i[active payment_due overdue], to: :suspended
    end

    # NOTE: Reactivation can happen after the user has paid an overdue invoice or subscription
    event :reactivate do
      transitions from: %i[suspended overdue deactivated], to: :active
    end

    event :deactivate do
      transitions from: %i[active payment_due overdue suspended], to: :deactivated
    end
  end

  def add_member(user)
    members << user
  end

  # Class methods
  def self.ransackable_attributes(_auth_object = nil)
    %w[display_name email tax_id]
  end

  private

  def format_tax_id
    self.tax_id = tax_id.upcase if tax_id.present?
  end
end
