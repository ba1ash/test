class GetTopPosts
  include Dry::Transaction

  InputSchema = Dry::Validation.Form do
    required(:number).filled(:int?)
  end

  step :validate
  step :retrieve

  def validate(input)
    result = InputSchema.call(input)
    result.success? ? Right(result.output) : Left(result.errors)
  end

  def retrieve(white_input)
    connection = ActiveRecord::Base.connection
    retrieve_top_posts = "SELECT title, content FROM posts ORDER BY average_rating DESC LIMIT :number"
    generate_json_after_retrieving = "SELECT COALESCE(array_to_json(array_agg(row_to_json(t))), '[]') FROM (#{retrieve_top_posts}) t;"
    result = connection.execute(
      ActiveRecord::Base.send(:sanitize_sql,
                              [generate_json_after_retrieving, number: white_input[:number]])
    )
    Right(result.first['coalesce'])
  end
end
