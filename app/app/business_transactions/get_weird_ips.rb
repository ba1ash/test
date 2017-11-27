class GetWeirdIps
  include Dry::Transaction

  step :retrieve

  def retrieve(input)
    result = ActiveRecord::Base.connection.execute(
      "SELECT COALESCE(array_to_json(array_agg(row_to_json(t))), '[]') FROM (SELECT ip, authors FROM ips) t;"
    )
    Right(result.first['coalesce'])
  end
end
