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
  - [Database management](#database-management)
    - [Resetting the databases](#resetting-the-databases)
  - [How to run the test suite](#how-to-run-the-test-suite)
  - [Services (job queues, cache servers, search engines, etc.)](#services-job-queues-cache-servers-search-engines-etc)
  - [Deployment instructions](#deployment-instructions)
  - [Development](#development)
  - [FAQs](#faqs)
    - [RubyMine](#rubymine)
      - [How do I disable these "Missing type signature" errors?](#how-do-i-disable-these-missing-type-signature-errors)
  - [Integration Partners](#integration-partners)
    - [PayPal](#paypal)
    - [Zoho CRM](#zoho-crm)
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
        <th>Essential</th>
    </tr>
</thead>
<tbody>
    <tr>
        <td>Rails</td>
        <td><code>16006</code></td>
        <td style="text-align: center">⭐️</td>
    </tr>
    <tr>
        <td>Postgres (app store)</td>
        <td><code>16032</code></td>
        <td style="text-align: center">⭐️</td>
    </tr>
    <tr>
        <td>Redis</td>
        <td><code>16079</code></td>
        <td style="text-align: center">⭐️</td>
    </tr>
    <tr>
        <td>Redis Commander (admin)</td>
        <td><code>16081</code></td>
        <td></td>
    </tr>
    <tr>
        <td>Mailhog</td>
        <td><code>8025</code></td>
        <td></td>
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

#### `PII_FILTER_ALLOW_ACCESS_TOKENS` (default = `false`)

> **BE CAREFUL NOT TO LEAK SENSITIVE INFORMATION INTO SOURCE CONTROL**. Cassettes are not encrypted and can be read by anyone with access to the repository. Ensure that you do not commit any sensitive information to the repository like access tokens for app integrations.

This configuration is intended to give us a way to allow requests under tests to call through to real world API endpoints that require an access token.

When using this configuration, you should start by ensuring that the `PII_FILTER_ALLOW_ACCESS_TOKENS` is set to `true` in your `.env.test` file.

Next, ensure that you comment out any steps that would normally stub out the request to the API endpoint in your test suite.

Finally, delete the `VCR` cassettes that would normally be used to stub out the request to the API endpoint.

Optionally, you can check for the cassette configuration matching the endpoint you're working on in the `config/vcr.rb` file and set the `record` option to `:new_episodes` or `:all` to ensure that the cassette is updated with the new response.

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
.docker/bin/start
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

Review [the development guide](./md/DEVELOPMENT.md).

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

### Zoho CRM

_Pending_

## Guides and References

> Disclaimer: website links may be broken if the publisher's have taken the sites down 🤷🏾‍♂️.

👉🏾 [Guides, articles & other helpful documentation](./md/GUIDES.md).

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
