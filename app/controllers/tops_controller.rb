class TopsController < ApplicationController
  before_action :set_api_key, only: :refresh
  require 'net/http'
  require 'uri'

  def index
    @tweets = Tweet.includes(:likes).order(id:'asc')
    @users = User.includes(:likes).sort {|a,b| b.likes.size <=> a.likes.size}
  end

  def refresh
    tweets = []
    all_tweets = Tweet.all.includes(:likes)
    @client.user_timeline("littlecheetah5", {count:100}).each do |t|
      if t.attrs[:entities][:user_mentions].length == 0
        tweet = all_tweets.find{|tw|tw.tweet_id == t.attrs[:id].to_s}
        tweet = Tweet.create(tweet_id:t.attrs[:id], tweet_text:t.attrs[:text]) unless tweet.present?
        tweets << tweet
        puts t.attrs[:favorite_count]
      end
    end
    # response = Net::HTTP.get('https://api.twitter.com', "/2/tweets/#{id}/liking_users")
    users = User.all
    likes = Like.includes(:tweet)
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
        user = users.find_by(user_id:u["id"])
        unless user.present?
          user = User.create(user_id:u["id"], username:u["username"], name:u["name"])
        end
        like = likes.detect{|l|l.tweet == t && l.user == user}
        unless like.present?
          # binding.pry
          Like.create(user:user, tweet:t)
        end
      end
    end
    redirect_to root_path
  end

  private

  def set_api_key
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.credentials.twitter[:api_key]
      config.consumer_secret     = Rails.application.credentials.twitter[:secret_key]
      config.access_token        = Rails.application.credentials.twitter[:access_token]
      config.access_token_secret = Rails.application.credentials.twitter[:secret_token]
    end
  end
end
