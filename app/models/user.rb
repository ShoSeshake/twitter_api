class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable, :omniauthable,
          :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  devise :omniauthable, omniauth_providers: %i[twitter]


  has_one :twitter_account
end
