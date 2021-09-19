class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :twitter_user_id, null:false
      t.string :twitter_username, null:false
      t.string :twitter_name, null:false
      t.references :user, null:false, foreign_key:true
      t.timestamps
    end
  end
end
