require 'test_helper'

class GettingAuthorsWithSameIpTest < ActionDispatch::IntegrationTest
  def test_three_posts_from_different_ips_by_different_authors
    post('/posts',
         params: { title: 'Title', content: 'Content', author: 'linus', ip: '123.123.123.124' },
         as: :json)
    post('/posts',
         params: { title: 'Title', content: 'Content', author: 'aaron', ip: '123.123.123.125' },
         as: :json)
    post('/posts',
         params: { title: 'Title', content: 'Content', author: 'jose', ip: '2001:0db8:85a3:0000:0000:8a2e:0370:7334' },
         as: :json)
    get('/ips', headers: { 'Accept' => 'application/json' })
    assert_equal(200, status)
    assert_equal(Oj.dump([{ ip: '123.123.123.124', authors: ['linus']},
                          { ip: '123.123.123.125', authors: ['aaron']},
                          { ip: '2001:db8:85a3::8a2e:370:7334', authors: ['jose']}]),
                 body)
  end

  def test_three_posts_from_same_ip_by_different_authors
    post('/posts',
         params: { title: 'Title', content: 'Content', author: 'linus', ip: '123.123.123.124' },
         as: :json)
    post('/posts',
         params: { title: 'Title', content: 'Content', author: 'aaron', ip: '123.123.123.124' },
         as: :json)
    post('/posts',
         params: { title: 'Title', content: 'Content', author: 'jose', ip: '123.123.123.124' },
         as: :json)
    get('/ips', headers: { 'Accept' => 'application/json' })
    assert_equal(200, status)
    assert_equal(Oj.dump([{ ip: '123.123.123.124', authors: ['linus', 'aaron', 'jose']}]), body)
  end

  def test_no_posts
    get('/ips', headers: { 'Accept' => 'application/json' })
    assert_equal(200, status)
    assert_equal('[]', body)
  end
end
