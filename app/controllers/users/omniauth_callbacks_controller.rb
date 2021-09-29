# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end
  def twitter
    callback_from :twitter
  end

  def facebook
    callback_from :facebook
  end


  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  private

  def callback_from(provider)
    provider = provider.to_s
    auth = request.env['omniauth.auth']
    user = User.find_by(uid:auth.uid, provider:provider)
    return sign_in_and_redirect user, event: :authentication if user.present?
    user = User.create(
      provider: provider,
      uid: auth.uid,
      password: "12345678",
      password_confirmation: "12345678",
      email: "#{auth.uid}@dummy.com",
      access_token: auth.credentials.token,
      secret_token: auth.credentials.secret,
    )
    twitter_account = TwitterAccount.find_by(twitter_user_id: user.uid)
    if twitter_account.present?
      twitter_account.update(user:user)
    else
      TwitterAccount.create!(
        twitter_user_id: user.uid,
        twitter_username: auth.info.nickname,
        twitter_name: auth.info.name,
        user: user,
      )
    end
    sign_in_and_redirect user, event: :authentication
  end


  def after_omniauth_failure_path_for(scope)
    root_path
    super(scope)
  end
end
