# frozen_string_literal: true

class Consultation < Product
  alias_attribute :consultant, :vendor
end
