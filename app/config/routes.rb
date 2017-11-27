Rails.application.routes.draw do
  root to: proc { [404, { 'Content-Type' => 'application/json'}, ['{"errors": {"message":"Not Found"}}']] }
  post '/posts' => 'posts#create'
  put '/posts/:id' => 'posts#rate', constraints: { id: /\d+/ }
  get '/posts/top/:number' => 'posts#top', constraints: { number: /\d+/ }
  get '/ips' => 'ips#list'
end
