# Heroku Timed Scaler

[![TravisCI](https://travis-ci.org/jelmersnoeck/heroku-timed-scaler.svg)](https://travis-ci.org/jelmersnoeck/heroku-timed-scaler)

Scale your Heroku apps on a time slot base.

![Preview](https://cdn-images-1.medium.com/max/800/1*O5wHwkbz3bpo0ksKgxilgQ.png)

## Installation

- Create a new Heroku app
- Add PG to your application
- Add Redis to your application
  - Add an ENV variable `REDIS_PROVIDER=REDIS_URL`, this is for Sidekiq
- Push application to Heroku
- Run migrations
- Set env variables:
  - HEROKU_OAUTH: your oauth token
  - HEROKU_APP_NAME: the application that you want to scale

## TODO

- Multiple app support
- Activity checks in workers (retries etc.)
- CSV import
- Install script
- Add ENV for additional extra time (scale 15 min before timeslot)
- HTTP Basic Auth
