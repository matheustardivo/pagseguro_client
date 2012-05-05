module PagseguroClient
  extend self

  @@config = nil

  def config_file
    Rails.root.join("config/pagseguro.yml")
  end

  def config?
    File.exist?(config_file)
  end

  def config
    raise MissingConfigurationError, "file not found on #{config_file.inspect}" unless config?

    @@config ||= YAML.load_file(config_file)

    if @@config == false || !@@config[Rails.env]
      raise MissingEnvironmentError, ":#{Rails.env} environment not set on #{config_file.inspect}"
    end

    @@config[Rails.env]
  end

  def base_url
    config["base_url"]
  end

  def token
    config["token"]
  end

  def email
    config["email"]
  end

  def payment_url(code)
    "#{base_url}/v2/checkout/payment.html?code=#{code}"
  end

  def notification_url(code)
    "#{base_url}/v2/transactions/notifications/#{code}"
  end

  class MissingEnvironmentError < StandardError; end
  class MissingConfigurationError < StandardError; end
end
