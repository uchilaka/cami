# frozen_string_literal: true

# Initialize a struct for the Business model
Struct.new('Company', :name, :email, :tax_id, keyword_init: true)
# Initialize a struct for vendor API credentials & config combos
#   saved in the app credentials file
Struct.new('VendorConfig', :base_url, :client_id, :client_secret, keyword_init: true)
