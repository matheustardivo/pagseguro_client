# encoding: utf-8

module PagseguroClient
  class Notification
    PAYMENT_METHOD = {
      1 => :credit_card,
      2 => :invoice,
      3 => :online_transfer,
      4 => :pagseguro,
      5 => :oi_paggo
    }
    
    STATUS = {
      1 => :pending,
      2 => :verifying,
      3 => :approved,
      4 => :available,
      6 => :refunded,
      7 => :canceled
    }
    
    attr_accessor :code, :order_id, :order_code, :status, :payment_method
    
    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end
    
    def self.retrieve(code)
      response = RestClient.get("#{PagseguroClient.base_url}/v2/transactions/notifications/#{code}",
        {
          params: {
            email: PagseguroClient.email, 
            token: PagseguroClient.token
          }
        }
      )

      doc = Nokogiri::XML(response.body)
      order_id = doc.xpath("//reference").text
      order_code = doc.xpath("//code").text
      status = doc.xpath("//status").text.to_i
      payment_method = doc.xpath("//paymentMethod/type").text.to_i
      
      Notification.new(
        code: code, 
        order_id: order_id, 
        order_code: order_code, 
        status: STATUS[status], 
        payment_method: PAYMENT_METHOD[payment_method]
      )
    end
  end
end
