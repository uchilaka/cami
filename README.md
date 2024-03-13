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

## Database management 

Review the list of available rake tasks for managing the `MongoDB` database:

```shell
bundle exec rake -T | grep mongoid

# Sample output
rake db:mongoid:create_collections             # Create collections for Mongoid models
rake db:mongoid:create_collections:force       # Drop and create collections for Mongoid models
rake db:mongoid:create_indexes                 # Create indexes specified in Mongoid models
rake db:mongoid:drop                           # Drop the database of the default Mongoid client
rake db:mongoid:purge                          # Drop all non-system collections
rake db:mongoid:remove_indexes                 # Remove indexes specified in Mongoid models
rake db:mongoid:remove_undefined_indexes       # Remove indexes that exist in the database but are not specified in Mongoid models
rake db:mongoid:shard_collections              # Shard collections with shard keys specified in Mongoid models
```

### Test

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

# List databases
show dbs

# Use the admin database
use admin

# Create a new user
db.createUser({
  user: "db_admin",
  pwd: `${process.env.MONGO_INITDB_ROOT_PASSWORD}`,
  roles: [
    { role: "dbOwner", db: "doc_store_development" },
    { role: "dbOwner", db: "doc_store_test" },
  ]
})

use doc_store_test

# Create a new user (for testing purposes)
db.createUser({
  user: "db_admin",
  pwd: passwordPrompt(),
  roles: [
    { role: "dbOwner", db: "doc_store_test" }
  ]
})

use doc_store_development

# Create a new user (for development purposes)
db.createUser({
  user: "db_admin",
  pwd: passwordPrompt(),
  roles: [
    { role: "dbOwner", db: "doc_store_development" }
  ]
})

# Example: Grant roles to an existing user
db.grantRolesToUser("db_admin", ["dbOwner"])
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

## Guides and References

- [MongoDB Tutorial](https://www.w3schools.com/mongodb/)
  - [Release: Official Atlas Github Action](https://www.mongodb.com/community/forums/t/introducing-the-offical-github-action-and-docker-image-for-atlas-cli/253891)
- [Rails API](https://api.rubyonrails.org/)
- [Rails Guides](https://guides.rubyonrails.org/)
  - [Autoloading and Reloading Constants](https://guides.rubyonrails.org/autoloading_and_reloading_constants.html)
    - [Single Table Inheritance](https://guides.rubyonrails.org/autoloading_and_reloading_constants.html#single-table-inheritance)
    - [Customizing Inflections](https://guides.rubyonrails.org/autoloading_and_reloading_constants.html#customizing-inflections)
  - [Rails Routing from the Outside In](https://guides.rubyonrails.org/routing.html)
  - [Active Record Migrations](https://guides.rubyonrails.org/active_record_migrations.html)
  - [Active Record Validations](https://guides.rubyonrails.org/active_record_validations.html)
  - [Active Record Callbacks](https://guides.rubyonrails.org/active_record_callbacks.html)
  - [Active Record Associations](https://guides.rubyonrails.org/association_basics.html)
    - [Single Table Inheritance](https://guides.rubyonrails.org/association_basics.html#single-table-inheritance-sti)
    - [Delegated Types](https://guides.rubyonrails.org/association_basics.html#delegated-types)
  - [Active Record Query Interface](https://guides.rubyonrails.org/active_record_querying.html)
  - [Active Record Scopes](https://guides.rubyonrails.org/active_record_querying.html#scopes)
  - [Multiple Databases](https://guides.rubyonrails.org/active_record_multiple_databases.html)
- [Introduction to Sidekiq for Rails](https://blog.appsignal.com/2023/09/20/an-introduction-to-sidekiq-for-ruby-on-rails.html)

## Future Work

- [ ] Setup secrets using [docker images' compatibility with secret files](https://docs.docker.com/compose/use-secrets/) 
