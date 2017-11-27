class RatePost
  include Dry::Transaction

  InputSchema = Dry::Validation.Form do
    required(:id).filled(:int?)
    required(:rating) { filled? & int? & included_in?([1, 2, 3, 4, 5]) }
  end

  FIND_POST = 'SELECT id, average_rating, number_of_ratings FROM posts WHERE id = :id FOR UPDATE;'
  UPDATE_POST_RATING = 'UPDATE posts SET average_rating = :new_average_rating, number_of_ratings = :new_number_of_ratings WHERE id = :id;'

  step :validate
  step :insert

  def validate(input)
    result = InputSchema.call(input)
    result.success? ? Right(result.output) : Left(result.errors)
  end

  def insert(white_input)
    connection = ActiveRecord::Base.connection
    connection.execute('BEGIN;')
    post_tuple = connection.execute(ActiveRecord::Base.send(:sanitize_sql, [FIND_POST, id: white_input[:id]])).first
    if post_tuple
      new_number_of_ratings = post_tuple['number_of_ratings'] + 1
      new_average_rating = ((post_tuple['average_rating'] || 1) * post_tuple['number_of_ratings'] + white_input[:rating]) / (new_number_of_ratings)
      connection.execute(
        ActiveRecord::Base.send(:sanitize_sql,
                                [UPDATE_POST_RATING,
                                 id: white_input[:id],
                                 new_average_rating: new_average_rating,
                                 new_number_of_ratings: new_number_of_ratings])
      )
      connection.execute('COMMIT;')
      Right(average_rating: new_average_rating)
    else
      connection.execute('COMMIT;')
      Left(message: 'Not Found')
    end
  end
end
