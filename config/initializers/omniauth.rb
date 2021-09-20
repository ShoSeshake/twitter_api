Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,
              Rails.application.credentials.twitter[:api_key],
              Rails.application.credentials.twitter[:secret_key]
end