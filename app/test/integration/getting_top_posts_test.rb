require 'test_helper'

class GettingTopPostsTest < ActionDispatch::IntegrationTest
  def test_getting_top_posts
    post('/posts',
         params: { title: 'Third rated post', content: 'Content', author: 'linus', ip: '123.123.123.123' },
         as: :json)
    id = Oj.load(body)['id']
    put("/posts/#{id}", params: { rating: 1 }, as: :json)

    post('/posts',
         params: { title: 'Top rated post', content: 'Content', author: 'linus', ip: '123.123.123.123' },
         as: :json)
    id = Oj.load(body)['id']
    put("/posts/#{id}", params: { rating: 4 }, as: :json)

    post('/posts',
         params: { title: 'Second rated post', content: 'Content', author: 'linus', ip: '123.123.123.123' },
         as: :json)
    id = Oj.load(body)['id']
    put("/posts/#{id}", params: { rating: 2 }, as: :json)

    get('/posts/top/2', headers: { 'Accept' => 'application/json' } )
    assert_equal(200, status)
    assert_equal('[{"title":"Top rated post","content":"Content"},{"title":"Second rated post","content":"Content"}]', body)
  end

  def test_zero_posts_exists
    get('/posts/top/2', headers: { 'Accept' => 'application/json' } )
    assert_equal(200, status)
    assert_equal('[]', body)
  end
end
