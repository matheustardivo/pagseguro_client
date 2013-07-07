require "coveralls"
Coveralls.wear!

require "bundler"

Bundler.setup(:default, :development)
Bundler.require

require "pagseguro_client"
