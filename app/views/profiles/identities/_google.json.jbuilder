# frozen_string_literal: true

# json.extract! identity, :email, :first_name, :last_name
json.id identity[:id]
json.email identity[:email]
json.given_name identity[:first_name]
json.family_name identity[:last_name]
