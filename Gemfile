source "https://rubygems.org"
ruby "2.2.2"

gem 'sinatra'
gem 'puma'
gem 'json'
gem 'rspec'
gem 'rack-test'
gem 'activerecord'
gem 'sinatra-activerecord'

group :test, :development do
  gem 'sqlite3'
  gem 'database_cleaner'
end

group :production do
  gem 'pg'
end
