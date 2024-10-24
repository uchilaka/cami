# Customer Accounts Management & Invoicing MVP

> Reference template: <https://github.com/IsraelDCastro/rails-vite-tailwindcss-template>

- [Customer Accounts Management \& Invoicing MVP](#customer-accounts-management--invoicing-mvp)
  - [Ruby Version](#ruby-version)
  - [Service/Vendor dependencies](#servicevendor-dependencies)
  - [System Dependencies](#system-dependencies)
  - [Configuration](#configuration)
    - [Development service ports](#development-service-ports)
  - [Running the app for the first time](#running-the-app-for-the-first-time)
    - [1. Setup the environment](#1-setup-the-environment)
    - [2. Install dependencies](#2-install-dependencies)
    - [3. Setup a GPG key for your Github account](#3-setup-a-gpg-key-for-your-github-account)
    - [4. Setup your application secrets](#4-setup-your-application-secrets)
    - [5. Start up the application's services](#5-start-up-the-applications-services)
    - [6. Initialize the database](#6-initialize-the-database)
    - [7. Start up the app](#7-start-up-the-app)
  - [Database management](#database-management)
    - [Setting up the document store in the test environment](#setting-up-the-document-store-in-the-test-environment)
    - [Resetting the databases](#resetting-the-databases)
    - [Managing the document store](#managing-the-document-store)
  - [How to run the test suite](#how-to-run-the-test-suite)
  - [Services (job queues, cache servers, search engines, etc.)](#services-job-queues-cache-servers-search-engines-etc)
  - [Deployment instructions](#deployment-instructions)
  - [Development](#development)
    - [Communities](#communities)
    - [Managing application secrets](#managing-application-secrets)
    - [Testing emails](#testing-emails)
    - [Using NGROK](#using-ngrok)
    - [Generating a `Monogid` Model](#generating-a-monogid-model)
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
    - [Issues with ESM Support](#issues-with-esm-support)
  - [Future Work](#future-work)

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

## Running the app for the first time

### 1. Setup the environment

> If you use [asdf](https://asdf-vm.com/guide/introduction.html), you will also need to setup the following plugins
> and install their corresponding versions with the `asdf install` command:
>
> - `asdf plugin add ruby`
> - `asdf plugin add nodejs`
> New to `asdf`? [here's a primer to get started](https://asdf-vm.com/guide/getting-started.html).

Review the `.env.example` file to ensure the environment variables are set. You can control which variables are made available in each environment while working locally using the following files:

- `.env.local`
- `.env.test`

The `.envrc` (see `.envrc.example`) file should be included for compatibility with other features like `docker compose` and simply sources the `.env.local` file.

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

## Database management

Review the list of available tasks for managing the `MongoDB` document store:

```shell
bundle exec rails -T | grep mongoid

# Sample output
rails db:mongoid:create_collections             # Create collections for Mongoid models
rails db:mongoid:create_collections:force       # Drop and create collections for Mongoid models
rails db:mongoid:create_indexes                 # Create indexes specified in Mongoid models
rails db:mongoid:drop                           # Drop the database of the default Mongoid client
rails db:mongoid:purge                          # Drop all non-system collections
rails db:mongoid:remove_indexes                 # Remove indexes specified in Mongoid models
rails db:mongoid:remove_undefined_indexes       # Remove indexes that exist in the database but are not specified in Mongoid models
rails db:mongoid:shard_collections              # Shard collections with shard keys specified in Mongoid models
```

### Setting up the document store in the test environment

> This guide is intended as a temporary solution until we can come up with something better for bringing up the document store with the right set of permissions the first time the application setup is run.

```shell
# Show help menu for mongosh
docker exec -it mongodb.accounts.larcity mongosh --help

# Run the command to initialize the database
docker exec -it mongodb.accounts.larcity mongosh \
  --authenticationDatabase admin
  --file ./development/mongodb/docker-entrypoint-initdb.d/init-doc-stores
  --username <MONGO_INITDB_ROOT_USERNAME>
  --password <MONGO_INITDB_ROOT_PASSWORD>

# Run the command to connect the mongodb container
bin/thor lx-cli:db:connect --mongodb
```

Once connected to the database instance, run the following commands to setup test credentials:

```js
// List databases
show dbs

// Use the admin database
use admin

// Create a new user
db.createUser({
  user: "db_admin",
  pwd: `${process.env.MONGO_INITDB_ROOT_PASSWORD}`,
  roles: [
    { role: "dbOwner", db: "doc_store_development" },
    { role: "dbOwner", db: "doc_store_test" },
  ]
})

use doc_store_test

// Create a new user (for testing purposes)
db.createUser({
  user: "db_admin",
  pwd: passwordPrompt(),
  roles: [
    { role: "dbOwner", db: "doc_store_test" }
  ]
})

use doc_store_development

// Create a new user (for development purposes)
db.createUser({
  user: "db_admin",
  pwd: passwordPrompt(),
  roles: [
    { role: "dbOwner", db: "doc_store_development" }
  ]
})

// Example: Grant roles to an existing user
db.grantRolesToUser("db_admin", ["dbOwner"])
```

### Resetting the databases

```shell
# To reset the active record database
bundle exec rails db:reset db:seed
# To reset the app store database
bundle exec rails db:mongoid:purge
```

### Managing the document store

A few helpful commands for managing the document store.

```shell
bundle exec rails mongoid --help
```

## How to run the test suite

> TODO: Add test suite instructions

## Services (job queues, cache servers, search engines, etc.)

> TODO: Add services

## Deployment instructions

> TODO: Add deployment instructions

## Development

### Communities

- Storybook Discord: <https://discord.gg/storybook/>

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

### Generating a `Monogid` Model

```shell
rails g model Invoice --orm=mongoid
```

After generating the model, if you would like to inherit application functionality for document records,
you can include the `DocumentRecord` concern in the model:

```ruby
class Invoice
  include DocumentRecord
end
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
- [Dynamic roles in a Rails app](https://nicholusmuwonge.medium.com/dynamic-roles-in-a-rails-app-using-rolify-devise-invitable-and-pundit-b72011451239)
- [Using yq to parse YAML (fixture) files](https://stackoverflow.com/a/67610900)

## Known issues

### Issues with ESM Support

> Link to a helpful comment on a related Github issue: <https://github.com/yarnpkg/yarn/issues/8994#issuecomment-1870052819>

Each time a new dependency is added, you'll need to nuke the `yarn.lock` file before `yarn test` is able to run successfully again. The error looks like this:

```shell
yarn run v1.22.21
$ jest
Error [ERR_REQUIRE_ESM]: require() of ES Module /opt/Developer/@larcity/account_manager/node_modules/string-width/index.js from /opt/Developer/@larcity/account_manager/node_modules/cliui/build/index.cjs not supported.
Instead change the require of index.js in /opt/Developer/@larcity/account_manager/node_modules/cliui/build/index.cjs to a dynamic import() which is available in all CommonJS modules.
    at Object.<anonymous> (/opt/Developer/@larcity/account_manager/node_modules/cliui/build/index.cjs:291:21)
error Command failed with exit code 1.
info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.
```

## Future Work

- [ ] Complete [integration of Storybook with Tailwind CSS](https://storybook.js.org/recipes/tailwindcss#3-add-a-theme-switcher-tool)
- [ ] Implement `withFormikDecorator` to support writing stories that include Formik forms (and remove dependency on `@bbbtech/storybook-formik` library - see [this Storybook 8 incompatibility issue](https://github.com/storybookjs/storybook/issues/26031))
- [ ] [Vite HMR](https://vite.dev/guide/features#hot-module-replacement) doesn't seem to be working
- [ ] A JS Auth flow to emit and retain the JWT token for frontend access control features and initialize the rails session for everything else
- [ ] Review Yahoo + Google [updated email sender requirements](https://help.brevo.com/hc/en-us/articles/14925263522578-Prepare-for-Gmail-and-Yahoo-s-new-requirements-for-email-senders) and make any needed changes to the Brevo configs
- [x] Implement forbidden rescue page (or just set a flash message and redirect to the root path)
- [ ] "Continue with Google" quick link in the profile dropdown
- [ ] Fix web concurrency support (issues here might be related to log streaming). Here's the error message: `objc[97397]: +[NSCharacterSet initialize] may have been in progress in another thread when fork() was called. We cannot safely call it or ignore it in the fork() child process. Crashing instead. Set a breakpoint on objc_initializeAfterForkError to debug`
- [ ] AASM for account status
- [ ] Setup and update production credentials in the `config/credentials/production.yml.enc` file
- [ ] Implement `:confirmable` to secure accounts when switching/adding auth providers
- [x] Implement magic links
- [ ] Implement Omniauth via apple
- [x] Implement FontAwesome library for [SVG icons](https://fontawesome.com/icons/google?f=brands&s=solid)
- [ ] Secure accounts with MFA
- [ ] Setup secrets using [docker images' compatibility with secret files](https://docs.docker.com/compose/use-secrets/)
- [ ] [Vite CJS API is deprecated and will be removed in v6](https://vitejs.dev/guide/troubleshooting.html#vite-cjs-node-api-deprecated). Update the `vite.config.js` file to use the ESM build instead
- [ ] [New ESLint configuration system is available](https://eslint.org/docs/latest/use/configure/configuration-files-new). You will need to create a new `eslint.config.js` file to use the new configuration system
- [ ] Confirm account changes with OTP (email, TOTP), magic links, or passkey
- [ ] Setup RSwag for baller request specs & API tools
- [ ] Setup [Flipper](https://www.flippercloud.io/docs/features) for feature flags
- [ ] [Knapsack Pro](https://docs.knapsackpro.com/knapsack_pro-ruby/guide/?rails=yes) for parallelizing tests
- [ ] Check out [Redis Stack for docker](https://hub.docker.com/r/redis/redis-stack) for advanced indexing & search features with redis data
- [ ] [Playwright](https://playwright.dev/docs/intro) E2E test suite
- [ ] Implement default authorization policies
- [ ] **Consolidate vite configuration & dependencies** right now, vite is a dependency of both the front and backend separately. Is there a better way?
- [ ] Address error from working on rails project in VSCode: `/Users/localadmin/.asdf/installs/ruby/3.2.2/bin/ruby: warning: Ruby was built without YJIT support. You may need to install rustc to build Ruby with YJIT.`
