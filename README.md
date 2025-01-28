# Customer Account Management & Invoicing ...Again

> Reference rails template: <https://github.com/IsraelDCastro/rails-vite-tailwindcss-template>

- [Customer Account Management \& Invoicing ...Again](#customer-account-management--invoicing-again)
  - [This again?](#this-again)
  - [Other guides](#other-guides)
  - [Ruby Version](#ruby-version)
  - [Service/Vendor dependencies](#servicevendor-dependencies)
  - [System Dependencies](#system-dependencies)
  - [Configuration](#configuration)
    - [Development service ports](#development-service-ports)
    - [Environment variables](#environment-variables)
      - [`LAN_SUBNET_MASK`](#lan_subnet_mask)
  - [Running the app for the first time](#running-the-app-for-the-first-time)
    - [1. Setup the environment](#1-setup-the-environment)
    - [2. Install dependencies](#2-install-dependencies)
    - [3. Setup a GPG key for your Github account](#3-setup-a-gpg-key-for-your-github-account)
    - [4. Setup your application secrets](#4-setup-your-application-secrets)
    - [5. Start up the application's services](#5-start-up-the-applications-services)
    - [6. Initialize the database](#6-initialize-the-database)
    - [7. Start up the app](#7-start-up-the-app)
  - [Running Storybook](#running-storybook)
    - [Publishing the latest Storybook](#publishing-the-latest-storybook)
    - [The Storybook Firebase project](#the-storybook-firebase-project)
    - [A note on Storybook auto-migrations](#a-note-on-storybook-auto-migrations)
  - [Database management](#database-management)
    - [Resetting the databases](#resetting-the-databases)
  - [How to run the test suite](#how-to-run-the-test-suite)
  - [Services (job queues, cache servers, search engines, etc.)](#services-job-queues-cache-servers-search-engines-etc)
  - [Deployment instructions](#deployment-instructions)
  - [Development](#development)
    - [Managing application secrets](#managing-application-secrets)
    - [Testing emails](#testing-emails)
    - [Using NGROK](#using-ngrok)
    - [Print key file](#print-key-file)
    - [Handling fixture files](#handling-fixture-files)
      - [Sanitizing an existing fixture file](#sanitizing-an-existing-fixture-file)
      - [Converting a JSON fixture file to a YAML fixture file](#converting-a-json-fixture-file-to-a-yaml-fixture-file)
  - [FAQs](#faqs)
    - [RubyMine](#rubymine)
      - [How do I disable these "Missing type signature" errors?](#how-do-i-disable-these-missing-type-signature-errors)
  - [Integration Partners](#integration-partners)
    - [PayPal](#paypal)
  - [Guides and References](#guides-and-references)
  - [Known issues](#known-issues)
    - [Deprecation notice for `fixture_path` in Rails 7.1](#deprecation-notice-for-fixture_path-in-rails-71)
  - [Future reading](#future-reading)
  - [Future Work](#future-work)

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

## Other guides

- [Modeling](./md/MODELING.md)
- [Scaffolding](./md/SCAFFOLDING.md)

## Ruby Version

- `3.2.2`

## Service/Vendor dependencies

- [**Ngrok**](https://dashboard.ngrok.com/cloud-edge/domains) for local development tunneling

## System Dependencies

System dependencies are defined in the following configuration files:

- `.tool-versions` (see `.tool-versions.example`)
- `Gemfile`
- `Brewfile`
- `package.json`
  - `yarn.lock`

## Configuration

### Development service ports

<table>
<thead>
    <tr>
        <th>Service</th>
        <th>Port</th>
    </tr>
</thead>
<tbody>
    <tr>
        <td>Rails</td>
        <td><code>16006</code></td>
    </tr>
    <tr>
        <td>Redis</td>
        <td><code>16079</code></td>
    </tr>
    <tr>
        <td>Postgres (app store)</td>
        <td><code>16032</code></td>
    </tr>
    <tr>
        <td>MongoDB (invoicing score)</td>
        <td><code>16017</code></td>
    </tr>
</table>

### Environment variables

#### `LAN_SUBNET_MASK`

This configuration is intended to give us a way to allow certain app management features
based on the virtual network location of our teams.

Specifically, this `ENV` variable is an override to configure access to the app's
[web console](https://github.com/rails/web-console)
(also see [the docs](https://github.com/rails/web-console?tab=readme-ov-file#configweb_consolepermissions), as well as `VirtualOfficeManager#web_console_permissions`).

The built-in configuration option is to set the following in the corresponding [custom credential file](https://guides.rubyonrails.org/security.html#custom-credentials):

> Tip: run `EDITOR=code bin/thor lx-cli:secrets:edit` in your development environment to edit the credentials file.

```yaml
web_console:
  permissions: 
```

## Running the app for the first time

### 1. Setup the environment

> If you use [asdf](https://asdf-vm.com/guide/introduction.html), you will also need to setup the following plugins
> and install their corresponding versions with the `asdf install` command:
>
> - `asdf plugin add ruby`
> - `asdf plugin add nodejs`
> New to `asdf`? [here's a primer to get started](https://asdf-vm.com/guide/getting-started.html).

Review the `.env.example` file to ensure the environment variables are set. You can
control which variables are made available in each environment while working locally
using the following files:

- `.env.local`
- `.env.test`

The `.envrc` (see `.envrc.example`) file should be included for compatibility with
other features like `docker compose` and simply sources the `.env.local` file.

### 2. Install dependencies

```shell
# Install system dependencies
brew bundle
# Setup the ASDF dependencies file
cp -v .tool-versions.example .tool-versions
# Set bundler location
bundle config set --local path ./vendor/bundle
# Install Ruby dependencies
bundle install
# Install Node dependencies
yarn install
```

### 3. Setup a GPG key for your Github account

Follow [this guide](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account). This will be needed by the application when it uses the `git-crypt` command to secure secret fixture files.

### 4. Setup your application secrets

Search for `development.yml.enc` to locate the entry in the KeePass store
with the application's encrypted secrets files.

Run the following code to update the application for the corresponding
environments. **You will need to do this before running the test suite**.

```shell
# Help menu for the secrets command
bin/thor help lx-cli:secrets:edit
# Edit the secrets file (for the development environment)
bin/thor lx-cli:secrets:edit --environment development
```

### 5. Start up the application's services

```shell
bin/start-docker
```

### 6. Initialize the database

```shell
# Get help with the DB setup command
bin/thor help lx-cli:db:setup
# Initialize the app store database
bin/thor lx-cli:db:setup --postgres
# Initialize the invoicing score database
bin/thor lx-cli:db:setup --mongodb
```

### 7. Start up the app

> You can also start up the app's non-dockerized services with the included IDE configurations for RubyMine in the `.ide-configs` folder.

This is the same command you'll need any time you want to start up the application:

```shell
bin/dev
```

## Running Storybook

> The `FeatureFlagsProvider` requires the application service running locally on port `6006` (currently broken, hence all features are disabled by default). This should be refactored to mock the response from `/api/features` and other endpoints needed to review components. See [this guide on mocking requests](https://storybook.js.org/docs/writing-stories/mocking-data-and-modules/mocking-network-requests) for more.

To review component stories, run:

```shell
yarn storybook
```

### Publishing the latest Storybook

> Review [the docs for multisite projects](https://firebase.google.com/docs/hosting/multisites).

- The Site ID is: `larcity-cami-components`
- The Storybook URL is: <https://larcity-cami-components.web.app>

```shell
yarn sb:publish
```

### The Storybook Firebase project

<https://console.firebase.google.com/project/larcity-ui-docs/overview>

### A note on Storybook auto-migrations

```shell
│   If you'd like to run the migrations again, you can do so by running 'npx storybook automigrate'                                 │
│                                                                                                                                   │
│   The automigrations try to migrate common patterns in your project, but might not contain everything needed to migrate to the    │
│   latest version of Storybook.                                                                                                    │
│                                                                                                                                   │
│   Please check the changelog and migration guide for manual migrations and more information:                                      │
│   https://storybook.js.org/docs/migration-guide                                                                                   │
│   And reach out on Discord if you need help: https://discord.gg/storybook  
```

## Database management

### Resetting the databases

```shell
# To reset the active record database
bundle exec rails db:reset db:seed
```

## How to run the test suite

> TODO: Add test suite instructions

## Services (job queues, cache servers, search engines, etc.)

> TODO: Add services

## Deployment instructions

> TODO: Add deployment instructions

## Development

### Managing application secrets

To edit credentials in your IDE, run the following command in your console:

```shell
bin/thor lx-cli:secrets:edit
```

To view help information about managing application credentials, run the following command in your console:

```shell
bin/rails credentials:help
```

To edit the credentials file for your development environment using the rails credentials scripts
and your command line, run the following code in your console:

```shell
EDITOR=nano bin/rails credentials:edit --environment ${RAILS_ENV:-development}
```

### Testing emails

> To enable email testing, set `SEND_EMAILS_ENABLED=yes` in your `.env.local` file.

To test emails in development, you can use the `Mailhog` service. If you are using the RubyMine configurations you will already have a dockerized `Mailhog` server running in debug mode. Otherwise, to start the service, run the following command in your console:

```shell
docker compose up -d mailhog
```

Your test inbox will be available at `http://localhost:8025`.

### Using NGROK

Follow these steps to setup `ngrok` for your local environment:

- Ensure you have updated your `.envrc` file with the `NGROK_AUTH_TOKEN`. You can get this from KeePass
- Run the following script to export the token to your local `ngrok.yml` config file:

  ```shell
  ngrok config add-authtoken ${NGROK_AUTH_TOKEN}
  ```

Then you can open a tunnel to your local environment by running:

```shell
thor lx-cli:tunnel:open_all
```

### Print key file

```shell
bin/thor help lx-cli:secrets:print_key
```

### Handling fixture files

A few helpful commands for handling fixture files.

#### Sanitizing an existing fixture file

```shell
# Show help menu for the sanitize command
bin/thor help lx-cli:fixtures:sanitize

# Sanitize the fixture file (outputs to the same directory as the fixture)
bin/thor lx-cli:fixtures:sanitize --file ./path/to/fixture.yml
```

#### Converting a JSON fixture file to a YAML fixture file

You can review [this guide](https://stackoverflow.com/a/67610900) for more tips
on using the `yq` command to transform (fixture) files.

```shell
# Convert the JSON fixture file to a YAML fixture file
yq -p json -o yaml ./path/to/fixture.json > ./path/to/fixture.yml
```

## FAQs

### RubyMine

#### How do I disable these "Missing type signature" errors?

> Go to `Settngs | Editor | Inspections | Ruby | RBS` and uncheck `Missing type signature`

## Integration Partners

### PayPal

- [Developer portal](https://developer.paypal.com/developer)
  - [Sandbox](https://developer.paypal.com/dashboard/applications/sandbox)
  - [Live](https://developer.paypal.com/dashboard/applications/live)
- [Invoicing API](https://developer.paypal.com/docs/api/invoicing/v2/)
  - [Webhooks](https://developer.paypal.com/docs/invoicing/webhooks/)

## Guides and References

- [RSpec](https://github.com/rspec/rspec-rails)
  - [RSwag](https://github.com/rswag/rswag)
  - [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers?tab=readme-ov-file#activemodel-matchers)
- [MongoDB Tutorial](https://www.w3schools.com/mongodb/)
  - [Release: Official Atlas Github Action](https://www.mongodb.com/community/forums/t/introducing-the-offical-github-action-and-docker-image-for-atlas-cli/253891)
  - [Mongoid](https://www.mongodb.com/docs/mongoid/current/)
    - [Customer Field Types](https://www.mongodb.com/docs/mongoid/current/reference/fields/#custom-field-types)
    - [Querying](https://www.mongodb.com/docs/mongoid/master/reference/queries/)
- [Rails API](https://api.rubyonrails.org/)
- [Rails Guides](https://guides.rubyonrails.org/)
  - [Autoloading and Reloading Constants](https://guides.rubyonrails.org/autoloading_and_reloading_constants.html)
    - [Single Table Inheritance](https://guides.rubyonrails.org/autoloading_and_reloading_constants.html#single-table-inheritance)
    - [Customizing Inflections](https://guides.rubyonrails.org/autoloading_and_reloading_constants.html#customizing-inflections)
  - [Routing from the Outside In](https://guides.rubyonrails.org/routing.html)
  - [Active Record](https://guides.rubyonrails.org/active_record_basics.html)
    - [Migrations](https://guides.rubyonrails.org/active_record_migrations.html)
    - [Validations](https://guides.rubyonrails.org/active_record_validations.html)
    - [Callbacks](https://guides.rubyonrails.org/active_record_callbacks.html)
    - [Associations](https://guides.rubyonrails.org/association_basics.html)
      - [Single Table Inheritance](https://guides.rubyonrails.org/association_basics.html#single-table-inheritance-sti)
      - [Delegated Types](https://guides.rubyonrails.org/association_basics.html#delegated-types)
    - [Query Interface](https://guides.rubyonrails.org/active_record_querying.html)
    - [Scopes](https://guides.rubyonrails.org/active_record_querying.html#scopes)
    - [Encryption](https://guides.rubyonrails.org/active_record_encryption.html)
  - [Multiple Databases](https://guides.rubyonrails.org/active_record_multiple_databases.html)
  - [Asset pipeline](https://guides.rubyonrails.org/asset_pipeline.html)
  - [The Flash](https://guides.rubyonrails.org/action_controller_overview.html#the-flash)
  - [Action Text](https://guides.rubyonrails.org/v7.1/action_text_overview.html)
  - [Time.now vs Time.current vs. DateTime.now](https://discuss.rubyonrails.org/t/time-now-vs-time-current-vs-datetime-now/75183)
- [Introduction to Sidekiq for Rails](https://blog.appsignal.com/2023/09/20/an-introduction-to-sidekiq-for-ruby-on-rails.html)
- [The beginner's guide to magic links](https://postmarkapp.com/blog/magic-links)
- [The complete guide for Deprecation Warnings in Rails](https://www.fastruby.io/blog/rails/upgrades/deprecation-warnings-rails-guide.html)
- [Devise](https://github.com/heartcombo/devise?tab=readme-ov-file#getting-started)
  - [Configure views](https://github.com/heartcombo/devise?tab=readme-ov-file#configuring-views)
  - [OmniAuth](https://github.com/heartcombo/devise/wiki/OmniAuth:-Overview)
    - [List of Strategies](https://github.com/omniauth/omniauth/wiki/List-of-Strategies)
    - [Devise Omniauth Custom Strategies](https://github.com/heartcombo/devise/wiki/OmniAuth:-Overview#custom-strategies)
- [Classic to Zeitwerk HOWTO](https://guides.rubyonrails.org/classic_to_zeitwerk_howto.html#why-switch-from-classic-to-zeitwerk-questionmark)
- [Pre-compiling assets](https://guides.rubyonrails.org/asset_pipeline.html#precompiling-assets)
- [Dart Sass for Rails](https://github.com/rails/dartsass-rails?tab=readme-ov-file#dart-sass-for-rails)
  - [Configuring builds](https://github.com/rails/dartsass-rails?tab=readme-ov-file#configuring-builds)
- [Fontawesome Icons](https://fontawesome.com/icons)
- [Pundit](https://github.com/varvet/pundit?tab=readme-ov-file#policies)
  - [Scopes](https://github.com/varvet/pundit?tab=readme-ov-file#scopes)
  - [Ensuring policies and scopes are used](https://github.com/varvet/pundit?tab=readme-ov-file#ensuring-policies-and-scopes-are-used)
  - [Closed systems](https://github.com/varvet/pundit?tab=readme-ov-file#closed-systems)
  - [Handling nil objects](https://github.com/varvet/pundit?tab=readme-ov-file#nilclasspolicy)
- [CanCanCan developer guide](https://github.com/CanCanCommunity/cancancan/blob/develop/docs/README.md) - an alternative to `Pundit`
- [Feature flags for backup providers](https://www.flippercloud.io/docs/guides/backup-providers) e.g. with feature flagging payment providers like Stripe, PayPal & SplitIt or auth providers like Apple, Google & native passwordless authentication
- [Using yq to parse YAML (fixture) files](https://stackoverflow.com/a/67610900)

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

- [ ] Tailwind CSS
  - [ ] [Base Styles](https://tailwindcss.com/docs/preflight)
  - [ ] [Layout](https://tailwindcss.com/docs/aspect-ratio)
  - [ ] [Flexbox & Grid](https://tailwindcss.com/docs/flex-basis)
  - [ ] [Customization](https://tailwindcss.com/docs/configuration)
- [ ] [Working with JSONB columns in your Active Record models with Active Model](https://betacraft.com/2023-06-08-active-model-jsonb-column/)
- [ ] [Building your Turbo application](https://turbo.hotwired.dev/handbook/building)
- [ ] Access Control
  - [ ] [Joining polymorphic associations in Active Record](https://veelenga.github.io/joining-polymorphic-associations/)
  - [ ] [Dynamic roles in a Rails app](https://nicholusmuwonge.medium.com/dynamic-roles-in-a-rails-app-using-rolify-devise-invitable-and-pundit-b72011451239)
  - [ ] [Using rolify with Devise and Authority](https://github.com/RolifyCommunity/rolify/wiki/Using-rolify-with-Devise-and-Authority)
- [ ] [Custom errors in rails](https://dev.to/ayushn21/custom-error-pages-in-rails-4i43)
- [ ] E2E testing
  - [ ] [Integrate Playwright with CypressOnRails](https://github.com/shakacode/cypress-on-rails?tab=readme-ov-file#totally-new-to-playwright)
  - [ ] [Running rails system tests with playwright instead of selenium](https://justin.searls.co/posts/running-rails-system-tests-with-playwright-instead-of-selenium/)
- [ ] [Inheriting class methods from modules / mixins in Ruby](https://stackoverflow.com/a/45127350)

## Future Work

- [ ] Configure error reporting: <https://guides.rubyonrails.org/error_reporting.html>
- [ ] Setup E2E test suite. Partial to Playwright over Cypress, but we should decide based on the needs of the project (See [future reading](#future-reading-))
- [ ] React Router v7 Future Flag Warnings
  - [ ] React Router will begin wrapping state updates in `React.startTransition` in v7. You can use the `v7_startTransition` future flag to opt-in early. For more information, see <https://reactrouter.com/v6/upgrading/future#v7_starttransition>.
  - [ ] Relative route resolution within Splat routes is changing in v7. You can use the `v7_relativeSplatPath` future flag to opt-in early. For more information, see <https://reactrouter.com/v6/upgrading/future#v7_relativesplatpath>
  - [ ] The persistence behavior of fetchers is changing in v7. You can use the `v7_fetcherPersist` future flag to opt-in early. For more information, see <https://reactrouter.com/v6/upgrading/future#v7_fetcherpersist>.
  - [ ] Casing of `formMethod` fields is being normalized to uppercase in v7. You can use the `v7_normalizeFormMethod` future flag to opt-in early. For more information, see <https://reactrouter.com/v6/upgrading/future#v7_normalizeformmethod>.
  - [ ] `RouterProvider` hydration behavior is changing in v7. You can use the `v7_partialHydration` future flag to opt-in early. For more information, see <https://reactrouter.com/v6/upgrading/future#v7_partialhydration>.
  - [ ] The revalidation behavior after 4xx/5xx `action` responses is changing in v7. You can use the `v7_skipActionErrorRevalidation` future flag to opt-in early. For more information, see <https://reactrouter.com/v6/upgrading/future#v7_skipactionerrorrevalidation>.
