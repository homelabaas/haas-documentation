# Homelab as a Service product documentation site

[![CircleCI](https://circleci.com/gh/homelabaas/haas-documentation/tree/master.svg?style=svg)](https://circleci.com/gh/homelabaas/haas-documentation/tree/master)

This documentation site uses MkDocs.

## Prerequisites

You will need docker and docker-compose installed.

## Development

Just run `./start-dev.sh` or `start-dev.ps1` to start up an mkdocs development container. This will mount your local working copy and will automatically update when you save changes.

Run `./stop-dev.sh` or `stop-dev.ps1` to stop the container.

## Deployment

Pushing to master will fire off a Circle CI build, which will automatically deploy the contents to production.