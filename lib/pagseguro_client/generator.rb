require "rails/generators/base"

module PagseguroClient
  class InstallGenerator < ::Rails::Generators::Base
    namespace "pagseguro_client:install"
    
    source_root File.dirname(__FILE__) + "/../../templates"

    def copy_configuration_file
      copy_file "config.yml", "config/pagseguro.yml"
    end
  end
end