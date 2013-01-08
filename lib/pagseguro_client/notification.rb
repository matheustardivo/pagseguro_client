# encoding: utf-8

module PagseguroClient
  class Notification < Transaction
    def self.url(code)
      PagseguroClient.notification_url(code)
    end
  end
end