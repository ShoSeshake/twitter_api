class User < ApplicationRecord
  belongs_to :auth, optional: true
  has_many :likes
  has_many :tweets, through: :likes
end
