class User < ActiveRecord::Base
	has_many :posts
end
class Post < ActiveRecord::Base
	has_one :user
end

