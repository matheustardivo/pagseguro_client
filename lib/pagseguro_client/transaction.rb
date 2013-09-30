# encoding: utf-8
module PagseguroClient
  class Transaction
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

    SHIPPING_TYPE = {
      1 => :pac,
      2 => :sedex
    }

    attr_accessor :code, :order_id, :status, :payment_method, :last_event_date, :sender, :address, :shipping

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def self.create_by_xml(xml)
      doc = Nokogiri::XML(xml)
      code = doc.xpath("//transaction/code").text
      order_id = doc.xpath("//reference").text
      status = doc.xpath("//status").text.to_i
      payment_method = doc.xpath("//paymentMethod/type").text.to_i
      last_event_date = doc.xpath("//transaction/lastEventDate").text
      email = doc.xpath("//transaction/sender/email").text
      name = doc.xpath("//transaction/sender/name").text
      phone = {
        area_code: doc.xpath("//transaction/sender/phone/areaCode").text,
        number: doc.xpath("//transaction/sender/phone/number").text
      }

      address = {
        country: doc.xpath("//transaction/shipping/address/country").text,
        state: doc.xpath("//transaction/shipping/address/state").text,
        city: doc.xpath("//transaction/shipping/address/city").text,
        postal_code: doc.xpath("//transaction/shipping/address/postalCode").text,
        district: doc.xpath("//transaction/shipping/address/district").text,
        street: doc.xpath("//transaction/shipping/address/street").text,
        number: doc.xpath("//transaction/shipping/address/number").text,
        complement: doc.xpath("//transaction/shipping/address/complement").text
      }

      shipping = {
        type: SHIPPING_TYPE[doc.xpath("//transaction/shipping/type").text.to_i],
        cost: doc.xpath("//transaction/shipping/cost").text.to_f
      }

      transaction = Transaction.new(
        code: code,
        order_id: order_id,
        status: STATUS[status],
        payment_method: PAYMENT_METHOD[payment_method],
        sender: {
          name: name,
          email: email,
          phone: phone
        },
        address: address,
        last_event_date: last_event_date,
        shipping: shipping
      )
    end

    def self.url(code)
      PagseguroClient.transaction_url(code)
    end

    def self.retrieve(code)
      response = RestClient.get(url(code),
        {
          params: {
            email: PagseguroClient.email,
            token: PagseguroClient.token
          }
        }
      )

      create_by_xml(response.body)
    end
  end
end
