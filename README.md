# Heroku Timed Scaler

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
