Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # Rails.application.config.middleware.insert_before Rack::Runtime, Rack::Cors do
  #   allow do
  #     origins 'example.com'
  #
  #     resource '*',
  #       headers: :any,
  #       methods: [:get, :post, :put, :patch, :delete, :options, :head]
  #   end
    allow do
      origins '*'   #note to self, tighten this up, this isnt secure enough
      resource '*',
      headers: :any,
      expose: ['access-token', 'uid', 'client', 'expiry', 'token-type'],
      max_age: 0
    end
  end
  