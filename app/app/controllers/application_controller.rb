class ApplicationController < ActionController::API
  before_action -> { render(nothing: true, status: 406) if request.accept !~ /application\/json/ }
end
