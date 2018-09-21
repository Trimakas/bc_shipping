#!/bin/bash
set -e

ARG="$(awk '{print $1}' <<< $1)"

# bundle install --jobs 20 --retry 5 --without development test

if [[ "$ARG" == "puma" ]]; then
  echo "Starting puma..."
  # npm install -g yarn
  # yarn install
  /usr/sbin/service cron start
  /usr/local/bin/bundle exec rake assets:precompile --trace
  /usr/local/bin/bundle exec rake db:migrate --trace
  /usr/local/bundle/bin/whenever --update-crontab
elif [[ "$ARG" == "sidekiq" ]]; then
  echo "Starting sidekiq..."
fi

cd /bytestand
exec "/usr/local/bin/bundle" "exec" "$@"
