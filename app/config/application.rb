require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    config.api_only = true
    config.action_controller.permit_all_parameters = true

    config.middleware.delete(Rack::Sendfile)
    config.middleware.delete(ActionDispatch::Static)
    config.middleware.delete(Rack::Head)
    config.middleware.delete(Rack::ConditionalGet)
    config.middleware.delete(Rack::ETag)
  end
end
