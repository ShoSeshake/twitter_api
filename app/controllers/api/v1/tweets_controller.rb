class Api::V1::TweetsController < ApiController

  # ActiveRecordのレコードが見つからなければ404 not foundを応答する
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: '404 not found' }, status: 404
  end

  def index
    @tweets = current_user.twitter_account.tweets.includes(:likes).order(tweet_created_at:'desc')
    render json: @tweets.to_json(include: [:likes])
  end
end