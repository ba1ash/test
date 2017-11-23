require File.expand_path('../../config/environment', __FILE__)
require 'action_dispatch/testing/integration'
require 'active_support/test_case'
require 'active_support/testing/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!(Minitest::Reporters::ProgressReporter.new,
                         ENV,
                         Minitest.backtrace_filter)
