require 'test_helper'

class RatingCreationTest < ActionDispatch::IntegrationTest
  def test_missing_rating
    put('/posts/1', params: {}, as: :json)
    assert_equal(422, status)
    assert_equal(Oj.dump(errors: { rating: ['is missing'] }), body)
  end

  def test_invalid_rating
    put('/posts/1', params: { rating: 10}, as: :json)
    assert_equal(422, status)
    assert_equal(Oj.dump(errors: { rating: ['must be one of: 1, 2, 3, 4, 5'] }), body)
  end

  def test_successful_post_rating
    post('/posts',
         params: { title: 'Title', content: 'Content', author: 'linus', ip: '123.123.123.123' },
         as: :json)
    id = Oj.load(body)['id']

    put("/posts/#{id}", params: { rating: 1 }, as: :json)
    assert_equal(200, status)
    assert_equal(Oj.dump(average_rating: 1), body)

    put("/posts/#{id}", params: { rating: 5 }, as: :json)
    assert_equal(200, status)
    assert_equal(Oj.dump(average_rating: 3.0), body)

    put("/posts/#{id}", params: { rating: 4 }, as: :json)
    assert_equal(200, status)
    assert_equal(Oj.dump(average_rating: 3.333333333333333), body)
  end
end
