class CreateTwitterAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :twitter_accounts do |t|
      t.string :twitter_user_id, null:false
      t.string :twitter_username, null:false
      t.string :twitter_name, null:false
      t.references :user, optional:true, foreign_key:true
      t.timestamps
    end
  end
end
