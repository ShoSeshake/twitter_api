class Api::V1::LikesController < ApiController

  # ActiveRecordのレコードが見つからなければ404 not foundを応答する
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: '404 not found' }, status: 404
  end

  def create
    client = set_client
    if params[:keyword].present?
      tweets = tweet_search(params[:keyword], params[:max_results], client)
      message =like_tweets(tweets, client)
    elsif params[:user_id].present?
      user = TwitterAccount.find_by(twitter_user_id:params[:user_id])
      tweets = tweets_by_user(user)
      message =like_tweets(tweets, client)
    else
      message = "エラーが発生しました。"
    end
    render json: {message:message}.to_json
  end

  private
  def tweet_search(keyword, max_results, client)
    all_tweets = Tweet.all.to_a
    users = TwitterAccount.all.to_a
    tweets = []
    client.search(keyword, result_type: "recent").attrs[:statuses].each do |t|
      if t[:entities][:user_mentions].length == 0
        u = t[:user]
        user = users.find{|us|us.twitter_user_id == u[:id].to_s}
        unless user.present?
          user = TwitterAccount.create(twitter_user_id:u[:id], twitter_username:u[:screen_name], twitter_name:u[:name])
          users << user
        end
        tweet = all_tweets.find{|tw|tw.tweet_id == t[:id].to_s}
        c = t[:created_at].split(' ')
        create_at = Time.new(c[5], c[1], c[2], c[3].split(':')[0], c[3].split(':')[1], c[3].split(':')[2])
        tweet = Tweet.create(tweet_id:t[:id], tweet_text:t[:text], tweet_created_at: create_at, twitter_account:user) unless tweet.present?
        all_tweets << tweet
        tweets << tweet
        break if tweets.length == max_results
      end
    end
    tweets
  end

  def tweets_by_user(user)
    tweets = []
    likes = Like.includes(:tweet).where(twitter_account:user)
    client = set_main_client
    all_tweets = Tweet.where(twitter_account:user)
    client.user_timeline(user.twitter_username, {count:100}).each do |t|
      tweet_data = t.attrs
      next unless tweet_data[:entities][:user_mentions].length == 0
      tweet = all_tweets.find{|tw|tw.tweet_id == tweet_data[:id].to_s}
      c = tweet_data[:created_at].split(' ')
      break if likes.detect{|l|l.tweet == tweet && l.twitter_account == user}.present?
      create_at = Time.new(c[5], c[1], c[2], c[3].split(':')[0], c[3].split(':')[1], c[3].split(':')[2])
      tweet = Tweet.create(tweet_id:tweet_data[:id], tweet_text:tweet_data[:text], tweet_created_at: create_at, twitter_account:user) unless tweet.present?
      tweets << tweet
      break if tweets.length > 20
    end
    tweets
  end

  def like_tweets(tweets, client)
    count = 0
    likes = Like.includes(:tweet, :twitter_account).all.to_a
    tweets.each do |tweet|
      existing_like = likes.detect{|l|l.tweet == tweet && l.twitter_account == current_user.twitter_account}
      next if existing_like.present?
      client.favorite(tweet.tweet_id)
      like = Like.create(twitter_account:current_user.twitter_account, tweet:tweet)
      count += 1
    end
    return "#{count}件のツイートをいいねしました。"
  end

  def set_client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.credentials.twitter[:api_key]
      config.consumer_secret     = Rails.application.credentials.twitter[:secret_key]
      config.access_token        = current_user.access_token
      config.access_token_secret = current_user.secret_token
    end
    client
  end


  def set_main_client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.credentials.twitter[:api_key]
      config.consumer_secret     = Rails.application.credentials.twitter[:secret_key]
      config.access_token        = Rails.application.credentials.twitter[:access_token]
      config.access_token_secret = Rails.application.credentials.twitter[:secret_token]
    end
    client
  end
end