module PagseguroClient
  class Railtie < Rails::Railtie
    generators do
      require "pagseguro_client/generator"
    end
  end
end