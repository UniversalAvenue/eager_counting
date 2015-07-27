class Comment < ActiveRecord::Base
  include EagerCounting::CountBy

  belongs_to :commentable, polymorphic: true
end
