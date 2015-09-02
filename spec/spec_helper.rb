ENV['RACK_ENV'] = "test"
ENV['NODE_ENROLL_SECRET'] = "valid_test"

require 'database_cleaner'

RSpec.configure do |config|

  config.before(:each) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
