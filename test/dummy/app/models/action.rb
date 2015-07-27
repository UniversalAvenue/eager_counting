class Action < ActiveRecord::Base
  include EagerCounting::CountBy

  belongs_to :visit
  belongs_to :product
end
