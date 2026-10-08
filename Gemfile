source "https://rubygems.org"
ruby "3.3.8"

gem "rails", "7.1.5"
gem "sprockets-rails"
gem "puma", ">= 5.0"
gem "jbuilder"
gem "bootsnap", require: false

group :development, :test do
  gem "sqlite3", "~> 1.4"
  gem "debug", platforms: %i[mri windows]
end

group :development do
  gem "web-console"
end

group :test do
  gem "minitest", "~> 5.25"
end

group :production do
  gem "pg", "~> 1.5"
end
