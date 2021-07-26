# Puma Rack App

A small Rack application using Puma and MongoDB to expose a REST API for Users.

## Usage Instructions

```bash
$ bundle install --path vendor/bundle

$ docker-compose up -d
$ open http://localhost:8081

$ bundle exec puma

$ http get localhost:9292/version
$ http get localhost:9292/health

$ http get localhost:9292/api/users
$ http --json post localhost:9292/api/users username=lreimer email=mario-leander.reimer@qaware.de
$ http get localhost:9292/api/users/:id     # insert _id from previous command
$ http delete localhost:9292/api/users/:id     # insert _id from previous command
```

## Maintainer

M.-Leander Reimer (@lreimer), <mario-leander.reimer@qaware.de>

## License

This software is provided under the MIT open source license, read the `LICENSE` file for details.
