# nodejs-perf-testing

A NodeJS app with experiments around performance. Find out more about how this
is used to test services in a CI/CD pipeline in the [accompanying article].

[accompanying article]: https://jsherz.com/ci/automation/gatling/cd/nodejs/2022/05/07/performance-testing-in-ci-cd.html

## Target areas

* Logging and serialisation
* Request body validation

## Installation

```bash
$ npm install
```

## Prepare database

```bash
docker-compose up -d
```

## Running the app

```bash
# generate PG DB types
$ npm run pgtyped

# development
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```

## Test

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```
