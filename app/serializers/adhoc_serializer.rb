# frozen_string_literal: true

class AdhocSerializer
  include ActiveModel::Serialization

  attr_reader :object

  def initialize(object, _options = nil)
    super()
    @object = object
  end

  def attributes
    {}
  end
end
