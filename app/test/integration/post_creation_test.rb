require 'test_helper'

class PostCreationTest < ActionDispatch::IntegrationTest
  def test_unacceptable_format
    post('/posts',
         params: { content: 'Content', author: 'linus', ip: '123.123.123.123' },
         as: :xml)
    assert_equal(406, status)
    assert_equal('', body.strip)
  end

  def test_missing_title
    response = post('/posts',
                    params: { content: 'Content', author: 'linus', ip: '123.123.123.123' },
                    as: :json)
    assert_equal(422, status)
    assert_equal(Oj.dump(errors: { title: ['is missing']} ), body)
  end

  def test_missing_content
    post('/posts',
         params: { title: 'Title', author: 'linus', ip: '123.123.123.123' },
         as: :json)
    assert_equal(422, status)
    assert_equal(Oj.dump(errors: { content: ['is missing']} ), body)
  end

  def test_missing_author
    post('/posts',
         params: { title: 'Title', content: 'Content', ip: '123.123.123.123' },
         as: :json)
    assert_equal(422, status)
    assert_equal(Oj.dump(errors: { author: ['is missing']} ), body)
  end

  def test_too_long_title
    post('/posts',
         params: { title: 't' * 401, content: 'Content', author: 'linus', ip: '123.123.123.123' },
         as: :json)
    assert_equal(422, status)
    assert_equal(Oj.dump(errors: { title: ['size cannot be greater than 400'] }), body)
  end

  def test_too_long_content
    post('/posts',
         params: { title: 'Title', content: 'c' * 25001, author: 'linus', ip: '123.123.123.123' },
         as: :json)
    assert_equal(422, status)
    assert_equal(Oj.dump(errors: { content: ['size cannot be greater than 15000'] }), body)
  end

  def test_too_long_author
    post('/posts',
         params: { title: 'Title', content: 'Content', author: 'l' * 101, ip: '123.123.123.123' },
         as: :json)
    assert_equal(422, status)
    assert_equal(Oj.dump(errors: { author: ['size cannot be greater than 100'] }), body)
  end

  def test_invalid_ip_address
    post('/posts',
         params: { title: 'Title', content: 'Content', author: 'linus', ip: 'invalid_ip_123.wer' },
         as: :json)
    assert_equal(422, status)
    assert_equal(Oj.dump(errors: { ip: ['is in invalid format'] }), body)
  end

  def test_successful_post_creation
    post('/posts',
         params: { title: 'Title', content: 'Content', author: 'linus', ip: '127.0.0.0' },
         as: :json)
    assert_equal(200, status)
    parsed_response = Oj.load(body)
    assert_equal(Integer, parsed_response['id'].class)
    assert_equal('Title', parsed_response['title'])
    assert_equal('Content', parsed_response['content'])
    assert_equal('linus', parsed_response['author'])

    get('/ips', headers: { 'Accept' => 'application/json' } )
    assert_equal(200, status)
    assert_equal(Oj.dump([{ ip: '127.0.0.0', authors: ['linus'] }]), body)
  end
end
