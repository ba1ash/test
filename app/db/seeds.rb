require 'faker'
require 'curb'
require 'uri'

url = ENV['URL'] || 'http://localhost:3000'
posts_number = ENV['POST_NUMBER'] || 200

begin
  if url =~ /\A#{URI::regexp(['http', 'https'])}\z/
    # healthcheck
    response = Curl.get("#{url}/ips") do |curl| 
      curl.headers['Accept'] = 'application/json'
    end

    xyz = (100..999).to_a
    rating = (1..5).to_a
    number_of_rates = (10..30).to_a
    authors = (1..100).map { "#{Faker::Name.unique.first_name.downcase}#{xyz.sample}" }
    ips_v4_addresses = (1..25).map { Faker::Internet.unique.ip_v4_address }
    ips_v6_addresses = (1..25).map { Faker::Internet.unique.ip_v6_address }
    ips = ips_v6_addresses + ips_v4_addresses

    thread_pool = Concurrent::FixedThreadPool.new(10)
    start_seeding = Time.now
    (1..posts_number).each do
      thread_pool.post do
        response = Curl.post("#{url}/posts",
                            Oj.dump(title: Faker::Lorem.sentence,
                                    content: Faker::Lorem.paragraph(350),
                                    author: authors.sample,
                                    ip: ips.sample)) do |curl|
          curl.headers['Accept'] = 'application/json'
          curl.headers['Content-Type'] = 'application/json'
        end
        id = Oj.load(response.body_str)['id']
        (1..number_of_rates.sample).each do
          Curl.put("#{url}/posts/#{id}", Oj.dump(rating: rating.sample)) do |curl| 
            curl.headers['Accept'] = 'application/json'
            curl.headers['Content-Type'] = 'application/json'
          end
        end
      end
    end
    thread_pool.shutdown
    thread_pool.wait_for_termination
    finish_seeding = Time.now
    puts finish_seeding - start_seeding
  else
    puts "The application URL seems to be not valid"
  end
rescue Curl::Err::ConnectionFailedError
  puts "Something wrong with app host"
end
