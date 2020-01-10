# Scorpio Sauce web service and administration

How to set it up:

## 1. [Install Ruby on Rails](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-18-04)

## 2. Install and configure the database manager
[Install MySQL Server](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-18-04) for development machines.
MySQL gem ´mysql2´ may require to install this library as a dependency

    $ apt install mysql-client

[Install PostgreSQL](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-18-04) for a production server.

Postgres gem ´pg´ may require to install this library as a dependency

    $ sudo apt install libpq-dev

## 3. Install RMagick dependencies
    apt install imagemagick libmagickwand-dev

## 4. Bundle install gems
### For a development machine
    $ bundle install --without production

### Or a production server
    $ bundle install --deployment --without development test

## 5. Setup database
### Generate secret_base
    $ EDITOR="vim" bin/rails credentials:edit

### For a development machine
    $ rails db:create
    $ rails db:migrate
    $ rails db:seed

### Or a production server
    $ rails db:create RAILS_ENV=production
    $ rails db:migrate RAILS_ENV=production
    $ rails db:seed RAILS_ENV=production

## 6. Execute the sql scripts in vendor (now done in seeds.rb)
### For MySql
    $ mysql -u <username> -p
    mysql > use <database>
    mysql > source /path_to_project/vendor/states.sql
    mysql > source /path_to_project/vendor/cities.sql

### And for PostgreSql
    $ psql -U <username> -d <database> -a -f /path_to_project/vendor/states.sql
    $ psql -U <username> -d <database> -a -f /path_to_project/vendor/cities.sql

or login to the psql console and execute the files there.

    $ psql -U <username> -d <database>
    =# \i /path_to_project/vendor/states.sql
    =# \i /path_to_project/vendor/cities.sql

## 7. Run the Web Server
If the app is running on a production server you might need to precompile
the project assets.

    rails assets:precompile RAILS_ENV=production
