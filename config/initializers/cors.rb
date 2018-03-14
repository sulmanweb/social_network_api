Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: %i[get post options delete put], expose: %w[utoken expiry token-type uid client]
  end
end