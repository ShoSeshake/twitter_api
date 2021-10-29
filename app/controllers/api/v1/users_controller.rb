class Api::V1::UsersController < ApiController
  before_action :set_api_key, only: :refresh

  # ActiveRecordのレコードが見つからなければ404 not foundを応答する
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: '404 not found' }, status: 404
  end

  def index
    # @tweets = Tweet.includes(:likes).order(id:'asc')
    twitter_account = TwitterAccount.find_by(twitter_username:"littlecheetah5")

    tweets = twitter_account.tweets
    @users = []
    users = Like.includes(:twitter_account).where(tweet:tweets).group_by(&:twitter_account)
    users.each do |user, likes|
      @users << {id:user.twitter_user_id, name:user.twitter_name, username:user.twitter_username, likes_count:likes.length}
    end
    @users = @users.sort{|a,b|b[:likes_count ] <=>  a[:likes_count]}
    render json: @users.to_json
  end

  def show
  end

  def set_id
    if user_signed_in?
      render json: current_user.to_json
    else
      render json: nil
    end
  end

  def refresh
    tweets = []
    twitter_account = TwitterAccount.find_by(twitter_username:"littlecheetah5")
    users = TwitterAccount.all.to_a
    all_tweets = Tweet.all.includes(:likes)
    @client.user_timeline(twitter_account.twitter_username, {count:100}).each do |t|
      tweet_data = t.attrs
      if tweet_data[:entities][:user_mentions].length == 0
        tweet = all_tweets.find{|tw|tw.tweet_id == tweet_data[:id].to_s}
        c = tweet_data[:created_at].split(' ')
        create_at = Time.new(c[5], c[1], c[2], c[3].split(':')[0], c[3].split(':')[1], c[3].split(':')[2])
        tweet = Tweet.create(tweet_id:tweet_data[:id], tweet_text:tweet_data[:text], tweet_created_at: create_at, twitter_account:twitter_account) unless tweet.present?
        tweets << tweet
      end
    end
    likes = Like.all
    tweets.each do |t|
      uri = URI.parse("https://api.twitter.com/2/tweets/#{t.tweet_id}/liking_users")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme === "https"
      headers = { "Authorization" => "Bearer #{Rails.application.credentials.twitter[:bearer_token]}" }
      req = Net::HTTP::Get.new(uri.path)
      req.initialize_http_header(headers)
      response = http.request(req)
      json_data =  JSON.parse response.body

      liked_users = json_data["data"]
      liked_users.each do |u|
        user = users.detect{|t_a| t_a.twitter_user_id == u["id"]}
        unless user.present?
          user = TwitterAccount.create(twitter_user_id:u["id"], twitter_username:u["username"], twitter_name:u["name"])
          users << user
        end
        like = likes.detect{|l|l.tweet == t && l.twitter_account == user}
        unless like.present?
          Like.create(twitter_account:user, tweet:t)
        end
      end
    end
    redirect_to root_path
  end

  def set_api_key
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.credentials.twitter[:api_key]
      config.consumer_secret     = Rails.application.credentials.twitter[:secret_key]
      config.access_token        = Rails.application.credentials.twitter[:access_token]
      config.access_token_secret = Rails.application.credentials.twitter[:secret_token]
    end
  end
end