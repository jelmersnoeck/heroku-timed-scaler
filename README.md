# Heroku Timed Scaler

[![TravisCI](https://travis-ci.org/jelmersnoeck/heroku-timed-scaler.svg)](https://travis-ci.org/jelmersnoeck/heroku-timed-scaler)

Scale your Heroku apps on a time slot base.

![Preview](https://cdn-images-1.medium.com/max/800/1*O5wHwkbz3bpo0ksKgxilgQ.png)

## Installation

### Create Heroku application

```
$ heroku apps:create <APPLICATION-NAME>
$ heroku addons:create heroku-postgresql:hobby-dev
$ heroku addons:create heroku-redis:hobby-dev
$ heroku config:set REDIS_PROVIDER=REDIS_URL
```

### Publish application

```
$ git push heroku master
$ heroku run bundle exec rake db:migrate
```

### Set application information

#### Retrieve auth token

```
$ heroku plugins:install git@github.com:heroku/heroku-oauth.git
$ heroku authorizations:create -d "Heroku Timed Scaler"
Created OAuth authorization.
  ID:          <ID>
  Description: Heroku Timed Scaler
  Scope:       global
  Token:       <TOKEN>
```

#### Set ENV

From the authorization above, use `TOKEN`. The `APP_NAME` is the application you
wish to scale up.

```
$ heroku config:set HEROKU_OAUTH=<TOKEN> HEROKU_APP_NAME=<APP_NAME>
```

## TODO

- Multiple app support
- Activity checks in workers (retries etc.)
- CSV import
- Install script
- Add ENV for additional extra time (scale 15 min before timeslot)
- HTTP Basic Auth
