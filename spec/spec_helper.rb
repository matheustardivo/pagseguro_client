require "coveralls"
Coveralls.wear!

ENV["RAILS_ENV"] = "test"

require "bundler"
require "rails"

Bundler.setup(:default, :development)
Bundler.require

require "pagseguro_client"
require "support/config/boot"
