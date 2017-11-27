require 'resolv'

class CreatePost
  include Dry::Transaction

  InputSchema = Dry::Validation.Form do
    required(:title) { filled? & str? & max_size?(400) }
    required(:content) { filled? & str? & max_size?(15_000) }
    required(:author) { filled? & str? & max_size?(100) }
    optional(:ip) { filled? & str? & format?(Resolv::AddressRegex) }
  end

  INSERT_POSTS =  "INSERT INTO posts (title, content, ip, author) VALUES (:title, :content, :ip, :author) RETURNING id;"
  INSERT_IPS = "INSERT INTO ips (ip, authors) VALUES (:ip, ARRAY[:authors]::varchar(100)[]) "\
               "ON CONFLICT (ip) DO UPDATE SET authors = ips.authors || ARRAY[:authors]::varchar(100)[] WHERE NOT(ips.authors @> ARRAY[:authors]::varchar(100)[]);"

  step :validate
  step :insert

  def validate(input)
    result = InputSchema.call(input)
    result.success? ? Right(result.output) : Left(result.errors)
  end

  def insert(white_input)
    connection = ActiveRecord::Base.connection
    connection.execute('BEGIN;')
    result_with_post_id = connection.execute(
      ActiveRecord::Base.send(:sanitize_sql,
                              [INSERT_POSTS,
                               title: white_input[:title],
                               content: white_input[:content],
                               ip: white_input[:ip],
                               author: white_input[:author]])
    )
    connection.execute(ActiveRecord::Base.send(:sanitize_sql,
                                               [INSERT_IPS, authors: [white_input[:author]], ip: white_input[:ip]])) if white_input[:ip]
    connection.execute('COMMIT;')

    if result_with_post_id.first
      Right(id: result_with_post_id.first['id'],
            title: white_input[:title],
            content: white_input[:content],
            author: white_input[:author])
    else
      Left(message: 'Something went wrong.')
    end
  end
end
