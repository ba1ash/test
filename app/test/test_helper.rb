require File.expand_path('../../config/environment', __FILE__)
require 'action_dispatch/testing/integration'
require 'active_support/test_case'
require 'active_support/testing/autorun'
require 'minitest/reporters'
require 'database_cleaner'

Minitest::Reporters.use!(Minitest::Reporters::ProgressReporter.new,
                         ENV,
                         Minitest.backtrace_filter)

DatabaseCleaner.strategy = :truncation

module BeforeSetupSettings
  def before_setup
    super
    DatabaseCleaner.start
  end
end

module AfterTeardownSettings
  def after_teardown
    DatabaseCleaner.clean
    super
  end
end

class Minitest::Test
  include BeforeSetupSettings
  include AfterTeardownSettings
end
