# LarCity Invoicing and Customer Accounts  Management Service MVP

- [LarCity Invoicing and Customer Accounts  Management Service MVP](#larcity-invoicing-and-customer-accounts--management-service-mvp)
  - [Ruby Version](#ruby-version)
  - [System Dependencies](#system-dependencies)
  - [Configuration](#configuration)
    - [Development service ports](#development-service-ports)
  - [Database creation](#database-creation)
  - [Database initialization](#database-initialization)
  - [How to run the test suite](#how-to-run-the-test-suite)
  - [Services (job queues, cache servers, search engines, etc.)](#services-job-queues-cache-servers-search-engines-etc)
  - [Deployment instructions](#deployment-instructions)
  - [Development](#development)
    - [Managing application secrets](#managing-application-secrets)
    - [Using NGROK](#using-ngrok)
  - [Guides and References](#guides-and-references)

## Ruby Version

- `3.2.2`

## System Dependencies

> TODO: Add system dependencies

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

## Database creation

> TODO: Add database creation instructions

## Database initialization

> TODO: Add database initialization instructions

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
bin/thor lar-city-cli:secrets:edit
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

### Using NGROK

Follow these steps to setup `ngrok` for your local environment:

- Ensure you have updated your `.envrc` file with the `NGROK_AUTH_TOKEN`. You can get this from KeePass
- Run the following script to export the token to your local `ngrok.yml` config file:

  ```shell
  ngrok config add-authtoken ${NGROK_AUTH_TOKEN}
  ```

Then you can open a tunnel to your local environment by running:

```shell
thor lar-city-cli:tunnel:open_all
```

## Guides and References

- [Introduction to Sidekiq for Rails](https://blog.appsignal.com/2023/09/20/an-introduction-to-sidekiq-for-ruby-on-rails.html)
