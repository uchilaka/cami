# frozen_string_literal: true

require_relative 'restricted_ips_constraint'

class AdminScopeConstraint
  attr_reader :allow_by_ip

  def initialize
    @allow_by_ip = RestrictedIpsConstraint.new
  end

  def matches?(request)
    allow_by_ip.matches?(request)
  end
end
