# frozen_string_literal: true

class Invoicer
  include ActiveModel::API
  include ActiveModel::Serialization
  extend ActiveModel::Callbacks
  extend ActiveModel::Validations::Callbacks
  include ActiveModel::Dirty

  attr_accessor :email

  define_attribute_methods :email

  def initialize(args = {})
    super
    @errors = ActiveModel::Errors.new(self)
    clear_attribute_changes(%w[email])
  end

  define_model_callbacks :initialize, :save, :update, :validation

  validate :email, email: true, allow_nil: true

  def attributes
    { 'email' => nil }
  end
end
