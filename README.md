# Customer Account Management & Invoicing ...Again

## This again?

Yep! Pivoting back to:

- **1 database ORM** PostgreSQL for all the magical things out of the box i.e. active record, active storage, action mailbox
- **A much simplified data model** with a focus on the core features of the app (no more profiles, STI account classes ...woof) 

Here are the scratch notes when exploring the `rails new` command:

```shell
# Install a required image library dependency via brew
brew install vips

# Setup rails 7
gem install rails --version 7.2

# Setup railsmdb
gem install railsmdb --pre

# Dry-run project setup (with MongoDB)
railsmdb new cami --no-rc --skip-webpack-install --skip-javascript \
	--skip-test --skip-system-test \
	--template ~/Developer/rails-vite-tailwindcss-template/template.rb \
	--react --pretend
	
# Dry-run project setup (with PostgreSQL: supports ActiveStorage, 
#   ActionMailbox & other ActiveRecord dependent features)
#   We've included ActiveStorage for ActionText (WYSIWYG editing).
#   Skipping ActionMailbox until we're ready for email automation.
rails new cami --no-rc --skip-webpack-install --skip-javascript \
	--database postgresql --skip-test --skip-system-test \
	--active-storage --skip-action-mailbox \
	--template ~/Developer/rails-vite-tailwindcss-template/template.rb \
	--react --pretend
	
# Active storage overview: https://guides.rubyonrails.org/active_storage_overview.html
# Action mailbox overview: https://guides.rubyonrails.org/action_mailbox_basics.html
```

## Known issues 

### Deprecation notice for `fixture_path` in Rails 7.1

```shell
Deprecation Warnings:

Rails 7.1 has deprecated the singular fixture_path in favour of an array.You should migrate to plural:


If you need more of the backtrace for any of these deprecations to
identify where to make the necessary changes, you can configure
`config.raise_errors_for_deprecations!`, and it will turn the
deprecation warnings into errors, giving you the full backtrace.
```

## Future reading 

- [ ] Working with JSONB columns in your Active Record models with Active Model: <https://betacraft.com/2023-06-08-active-model-jsonb-column/>
- [ ] Building your Turbo application: <https://turbo.hotwired.dev/handbook/building>
- [ ] Custom errors in rails: <https://dev.to/ayushn21/custom-error-pages-in-rails-4i43>
- [ ] E2E testing
  - [ ] Integrate Playwright with CypressOnRails: <https://github.com/shakacode/cypress-on-rails?tab=readme-ov-file#totally-new-to-playwright>
  - [ ] Running rails system tests with playwright instead of selenium: https://justin.searls.co/posts/running-rails-system-tests-with-playwright-instead-of-selenium/
- [ ] Inheriting class methods from modules / mixins in Ruby: <https://stackoverflow.com/a/45127350>

## Future Work

- [ ] Configure error reporting: <https://guides.rubyonrails.org/error_reporting.html>
- [ ] Setup E2E test suite. Partial to Playwright over Cypress, but we should decide based on the needs of the project (See [future reading](#future-reading-))