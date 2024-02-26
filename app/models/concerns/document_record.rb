# frozen_string_literal: true

# Mongoid guide: https://www.mongodb.com/docs/mongoid/current/installation/
module DocumentRecord
  extend ActiveSupport::Concern

  included do
    include Mongoid::Document
    include Mongoid::Timestamps
  end
end
