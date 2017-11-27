# README

* Description

  - Cut out all unnessary middlewares, railties, initializers from `rails`.
  - Patch `rails` to use `oj` for parsing incoming json messages.
  - Delegate json generation to postgresql where possible, use `oj` where not.
  - Use `dry-validation` for validation of parsed incoming json messages.
  - Use `dry-transaction` for 'business logic' organization (app/business_transactions/*)
  - I planned to use two kind of tests(unit and integration), but only integration ones has been used by me.
  - Additional points can be found in commit messages

* Prerequisites

  * Docker
  * Docker Compose

* Available environment variables

  - RACK_ENV 
  - DISABLE_DATABASE_ENVIRONMENT_CHECK
    
    Control possibility to drop | schema:load production db
  - URL
  
    URL where our service is running. Used by db/seeds.rb script
  - POST_NUMBER
    
    Number of posts to generate. Used by db/seeds.rb script

* Installation process
  - `docker-compose build`
  - `RACK_ENV=production docker-compose run api bundle exec bin/rails db:schema:load`

* Run service
  - `RACK_ENV=production docker-compose run`
  
    Service is available on 3000 port of local machine.

* Seed the database
  
  - `docker-compose exec api bundle exec bin/rails db:seed`
  
    The script send real request using `curb` and thread pool to our web service.
    URL and POST_NUMBER is actual here, `http://localhost:3000` and `200` are the default values respectively
    I've tested seeding ~400k of posts. It takes ~2h on my laptop.





