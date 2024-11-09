# frozen_string_literal: true

# json.extract! identity, :id, :email, :image_url
json.id identity[:id]
json.email identity[:email]
json.image_url identity[:image_url]
json.given_name identity[:first_name]
json.family_name identity[:last_name]
