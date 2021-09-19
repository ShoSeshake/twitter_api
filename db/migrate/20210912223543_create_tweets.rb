class CreateTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :tweets do |t|
      t.string :tweet_id, null:false
      t.text :tweet_text, null:false
      t.references :user, foreign_key:true, optional:true
      t.timestamps
    end
  end
end
