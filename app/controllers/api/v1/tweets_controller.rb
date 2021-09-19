class Api::V1::TweetsController < ApiController

  # ActiveRecordのレコードが見つからなければ404 not foundを応答する
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: '404 not found' }, status: 404
  end

  def index
    @tweets = Tweet.includes(:likes).order(id:'desc')
    render json: @tweets.to_json(include: [:likes])
  end
end