# frozen_string_literal: true

require_relative 'restricted_ips_constraint'

class AdminScopeConstraint
  attr_reader :allow_by_ip

  def initialize
    @allow_by_ip = RestrictedIpsConstraint.new
  end

  def matches?(request)
    # return true if allow_by_ip.matches?(request)
    #
    # raise Errors::ElevatedPrivilegesRequired, 'Forbidden Access to admin scope' \
    #   if %r{/admin/}.match(request.path)
    #
    # false
    allow_by_ip.matches?(request)
  end
end
