# frozen_string_literal: true

json.array! @countries do |country|
  next if country[:dial_code].blank?

  json.extract! country, :id, :name, :alpha2, :dial_code
end
