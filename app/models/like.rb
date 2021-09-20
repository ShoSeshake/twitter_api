class Like < ApplicationRecord
  belongs_to :twitter_account
  belongs_to :tweet
end
