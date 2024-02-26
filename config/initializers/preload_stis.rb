# frozen_string_literal: true

# Doc on pre-loading collapsed directories: https://guides.rubyonrails.org/autoloading_and_reloading_constants.html#option-2-preload-a-collapsed-directory
accounts = "#{Rails.root}/app/models/accounts"

Rails.autoloaders.main.collapse(accounts) # Not a namespace

unless Rails.application.config.eager_load
  Rails.application.config.to_prepare do
    Rails.autoloaders.main.eager_load_dir(accounts)
  end
end
