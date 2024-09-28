# frozen_string_literal: true

# 20240928120806_tag_vendor_accounts.rb
class TagVendorAccounts < ActiveRecord::Migration[7.0]
  def up
    Account.where(slug: account_slugs).find_each do |account|
      account.add_role(:vendor)
    end
    Account.where(slug: config_slugs).find_each do |account|
      account.add_role(:system)
    end
  end

  def down
    Account.where(slug: account_slugs).find_each do |account|
      account.remove_role(:vendor)
    end
    Account.where(slug: config_slugs).find_each do |account|
      account.remove_role(:system)
    end
  end

  private

  def account_slugs
    config_slugs.reject { |s| non_vendor_slugs.include?(s) }
  end

  def config_slugs
    YAML
      .load_file(Rails.root.join('spec/fixtures/businesses.yml'))
      .pluck('slug')
  end

  def non_vendor_slugs
    %w[larcity acme]
  end
end
