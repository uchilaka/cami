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
