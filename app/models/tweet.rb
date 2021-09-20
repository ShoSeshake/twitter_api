class Tweet < ApplicationRecord
  belongs_to :twitter_account
  has_many :likes
end
