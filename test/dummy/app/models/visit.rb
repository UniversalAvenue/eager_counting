class Visit < ActiveRecord::Base
  include EagerCounting::CountBy

  belongs_to :place
  belongs_to :user

  has_many :actions
end
