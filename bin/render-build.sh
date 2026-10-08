#!/usr/bin/env bash
set -o errexit

# Use the selected Ruby to execute Bundler, rather than a bundle executable
# whose shebang may point to the platform's default Ruby.
ruby -v
ruby -S bundle --version
ruby -S bundle install
ruby -S bundle exec rails assets:precompile
ruby -S bundle exec rails assets:clean
ruby -S bundle exec rails db:migrate
ruby -S bundle exec rails db:seed
