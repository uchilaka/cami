# frozen_string_literal: true

class ApplicationSupport < Product
  alias_attribute :provider, :vendor
end
