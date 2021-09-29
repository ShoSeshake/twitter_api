class CreateTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :tweets do |t|
      t.string :tweet_id, null:false
      t.text :tweet_text, null:false
      t.datetime :tweet_created_at, null:false
      t.references :twitter_account, foreign_key:true, null:false
      t.timestamps
    end
  end
end
