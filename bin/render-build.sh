#!/usr/bin/env bash
set -o errexit

bundle install
bundle exec rake db:create RAILS_ENV=production || echo "Database already exists"
bundle exec rake db:migrate RAILS_ENV=production