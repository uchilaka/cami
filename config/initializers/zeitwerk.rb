# frozen_string_literal: true

# Customizing inflections https://guides.rubyonrails.org/autoloading_and_reloading_constants.html#customizing-inflections
Rails.autoloaders.main.inflector.inflect(
  'lar-city' => 'LarCity',
  'vat' => 'VAT'
)

# Ignoring resources https://guides.rubyonrails.org/classic_to_zeitwerk_howto.html#having-app-in-the-autoload-paths
Rails.autoloaders.main.ignore('lib/assets')
