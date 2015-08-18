ENV['RACK_ENV'] = "test"
ENV['NODE_ENROLL_SECRET'] = "valid_test"

require 'database_cleaner'

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
  end

  config.after(:suite) do
    DatabaseCleaner.clean
  end

end
