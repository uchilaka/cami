# frozen_string_literal: true

require 'fileutils'

class AppUtils
  def self.yes?(value)
    return true if [true, 1].include?(value)
    return false if value.nil?

    /^Y(es)?|^T(rue)|^On$/i.match?(value.to_s.strip)
  end
end
