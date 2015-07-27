class Place < ActiveRecord::Base
  belongs_to :country

  has_many :comments, as: :commentable
  has_many :visits
end
