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

### Additional scaling time

You might want to make sure your application has scaled before the given time
slot. To do this, you can set a `SCALING_TIME` ENV variable. This will add the
given amount of time (in minutes) to your time slot.

Example, you set SCALING_TIME to 15 (minutes). Your time slot is at 15:30 until
16:30.

To start the scaling, this would mean it would scale up your application at
15:15. At 16:45, it will scale down your application again to the initial
settings.

```
$ heroku config:set SCALING_TIME=15
```

### HTTP Basic Auth

If you want to protect your application, there's a simple way to put HTTP Basic
Auth in front.

```
$ heroku config:set HTTP_AUTH_USER=<USERNAME> HTTP_AUTH_PASS=<PASSWORD>
```

## TODO

- Multiple app support
- Activity checks in workers (retries etc.)
- CSV import
- Install script
