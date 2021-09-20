module Api
  module V1
    module Auth
      class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
        skip_before_action :skip_session

        def redirect_callbacks
          super
        end
        def omniauth_success
          super
          update_auth_header
        end

        def omniauth_failure
          super
        end

        protected
        def get_resource_from_auth_hash
          super
          @resource.credentials = auth_hash["credentials"]
          clean_resource
        end

        def render_data_or_redirect(message, data, user_data = {})
          if Rails.env.production?
            if ['inAppBrowser', 'newWindow'].include?(omniauth_window_type)
              render_data(message, user_data.merge(data))
            elsif auth_origin_url
              redirect_to DeviseTokenAuth::Url.generate(auth_origin_url, data.merge(blank: true))
            else
              fallback_render data[:error] || 'An error occurred'
            end
          else
            render json: @resource, status: :ok
          end
        end

        def clean_resource
          @resource.name = strip_emoji(@resource.name)
          @resource.nickname = strip_emoji(@resource.nickname)
        end

        def strip_emoji(str)
          str.encode('SJIS', 'UTF-8', invalid: :replace, undef: :replace, replace: '').encode('UTF-8')
        end


    # def omniauth_success
    #   super
    #   update_auth_header
    #   data = request.headers['action_dispatch.request.unsigned_session_cookie']['dta.omniauth.auth']
    #   create_account(data)
    # end

    # protected

    # # To avoid ActiveModel::ForbiddenAttributesError
    # def assign_provider_attrs(user, auth_hash)
    #   case auth_hash["provider"]
    #   when "twitter"
    #     user.assign_attributes({
    #       email: auth_hash["info"]["email"]
    #       })
    #   else
    #     super
    #   end
    # end

    # def create_account(auth_hash)
    #   info = auth_hash['info']
    #   name = info['nickname']
    #   user_record = User.find_by(uid:info['uid'])
    #   twitter_user_id = get_id(name)
    #   twitter_account = TwitterAccount.find_by(twitter_user_id: twitter_user_id)
    #   if twitter_account.present?
    #     twitter_account.update(user:user_record)
    #   else
    #     TwitterAccount.create!(
    #       twitter_user_id: twitter_user_id,
    #       twitter_username: name,
    #       twitter_name: info['name'],
    #       user: user_record,
    #     )
    #   end
    # end

    # def get_id(name)
    #   response = get_response("/2/users/by/username/#{name}")
    #   return response['data']['id']
    # end
      end
    end
  end
end