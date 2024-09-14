# frozen_string_literal: true

require 'json'

module PIISanitizer
  extend PIIHelper

  def self.sanitize(data)
    JSON.generate(sanitize_json(data))
  end
end
