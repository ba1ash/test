class PostsController < ApplicationController
  def create
    CreatePost.new.call(params.to_hash) do |matcher| 
      matcher.success { |post| render(status: 200, json: post) }
      matcher.failure(:validate) { |errors| render(status: 422, json: { errors: errors }) }
      matcher.failure(:insert) { |errors| render(status: 500, json: { errors: errors}) }
    end
  end

  def rate
    RatePost.new.call(params.to_hash) do |matcher| 
      matcher.success  { |post| render(status: 200, json: post) }
      matcher.failure(:validate)  { |errors| render(status: 422, json: { errors: errors }) }
      matcher.failure(:insert)  { |errors| render(status: 500, json: { errors: errors}) }
    end
  end

  def top
    GetTopPosts.new.call(params.to_hash) do |matcher| 
      matcher.success { |posts| render(status: 200, json: posts) }
      matcher.failure(:validate)  { |errors| render(status: 422, json: { errors: errors }) }
    end
  end
end
