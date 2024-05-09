if heroku?
  Sidekiq.configure_server do |config|
    config.redis = {ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE}}
  end

  Sidekiq.configure_client do |config|
    config.redis = {ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE}}
  end
end

if Rails.env.development?
  Sidekiq.configure_server do |config|
    config.redis = { url: "redis://localhost:6379/10" }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: "redis://localhost:6379/10" }
  end
end

if Rails.env.development?
  Sidekiq.configure_server do |config|
    config.logger = Logger.new(Rails.root.join("log/sidekiq_development.log"))
    config.logger.level = Logger::DEBUG
  end
elsif Rails.env.test?
  Sidekiq.configure_server do |config|
    config.logger = Logger.new(Rails.root.join("log/sidekiq_test.log"))
    config.logger.level = Logger::DEBUG
  end
end
