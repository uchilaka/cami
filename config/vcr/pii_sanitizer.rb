# frozen_string_literal: true

require 'json'

module PIISanitizer
  extend PIIHelper

  def self.sanitize(data)
    # Include the `sanitize_json` function from previous example
    JSON.generate(sanitize_json(data))
  end
end
