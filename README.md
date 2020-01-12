# Tonsser Challenge
  I have decided to call my model for Players instead of Users, so the base endpoint is:
  * /players 
  
  I have used Devise with JWT tokens, and except for logging in or creating a Player, you need to
  be logged in to use the API.
  
  The API is documented with OpenApi and when the server is running it is available on:
  * http://localhost:3000/api-docs/index.html
  
  There you can login to a Player's account, by using the the /players/login endpoint and copying the bearer
  token into the value box presented when pressing the Authorize button.

  Ignoring the generated code and initializers, the meat of the code resides in these Directories:
  * /app/controllers
  * /app/models
  * /app/representations
  * /db/migrate
  * /spec
  
  And these Files:
  * /config/application.rb
  * /config/routes.rb
  * /config/initializers/devise.rb

### Follow-up questions
  #### Potential pitfalls
  * Long running synchronous methods, that block the API
  * Forgetting indexes on the Database, for join and sorting columns.
  * Having State in the API, thereby requiring sticky sessions
  
  #### When and how to scale
  This solution scales ok. You can come a long way with database indexes, including 
  text indexes for search, function indexes, and combined indexes enabling index only searches 
  on lists.
  
  But when the time comes, which you should be measuring, then:
  * Using asynchronous jobs through a queue(s), such as Sidekiq and Redis
  * File uploads to S3 or similar and file downloads through a CDN
  * Elasticsearch for text searches
  * Memcached or similar for caching expensive queries or operations, with cache busting on related updates.
  * Multiple servers behind a load-balancer.
  * Using databases with read-only copies (such as AWS Aurora RDS), moving your read operations to read from 
    the read-only copies, and only write operations, operating on the master db.
  * If appropriate, distributed services
  
  #### Club followers design
  I would probably create 2 extra model classes:
  * Club
  * ClubAdmin
  
  Create a many to many relation between club and players.
  
  Where the club admin is/are the people who can manage the Club.
  

#### Environment:

* Ruby version 2.6.4
* Rails version 5.2.4.1
* Postgres version 12.1

Development database can be set up by running in docker container:
* docker ps run -d --name postgres-dev -e POSTGRES_PASSWORD=player-api-development -e POSTGRES_USER=player-api -e POSTGRES_DB=player-api_development -p 5432:5432 postgres:12.1

Test DB is configured to run on port 6543, so both DB's can run simultaneously:
* docker ps run -d --name postgres-test -e POSTGRES_PASSWORD=player-api-test -e POSTGRES_USER=player-api -e POSTGRES_DB=player-api_test -p 6543:5432 postgres:12.1

#### Run tests
* rails db:migrate RAILS_ENV=test
* bundle exec rspec


### Test the API with OpenApi
* rails db:migrate
* rails db:seed
* rails server

Goto http://localhost:3000/api-docs/index.html

##### Create Player and log in:
* POST /players
* POST /players/login

#### Installed gems (production)

* devise
* devise-jwt
* rswag-api
* rswag-ui
* acts_as_api

#### Installed gems (test)

* rspec-rails
* rswag-specs
* factory-bot-rails
