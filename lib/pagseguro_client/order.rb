module PagseguroClient
  class Order

    attr_accessor :id, :products

    def initialize(order_id)
      self.id = order_id
      self.products = []
    end

    # The allowed values are:
    # - id (Required. Should match the product in your database)
    # - description (Required. Identifies the product)
    # - amount (Required. If float, will be multiplied by 100 cents)
    # - quantity (Optional. If not supplied, use 1)
    def add(options)
      products.push(options)
    end

    def data
      data = { email: PagseguroClient.email, token: PagseguroClient.token, currency: "BRL", reference: id }
      data["redirectURL"] = PagseguroClient.redirect_url if PagseguroClient.redirect?

      products.each_with_index do |item, index|
        index += 1
        data["itemId#{index}"] = item[:id]
        data["itemDescription#{index}"] = item[:description].to_s.unpack("U*").pack("C*")
        data["itemAmount#{index}"] = item[:amount]
        data["itemQuantity#{index}"] = item[:quantity] || 1
      end

      data
    end

    def parse_response(xml)
      doc = Nokogiri::XML(xml)

      # Verify if this is an error
      unless doc.css("error").empty?
        code = doc.xpath("//code").text
        message = doc.xpath("//message").text
        PagseguroError.new(code, message)

      else
        code = doc.xpath("//code").text
        {
          code: code,
          url: PagseguroClient.payment_url(code)
        }
      end
    end

    # Send a new payment request to Pagseguro
    # Returns the URL to redirect your user to complete the payment in Pagseguro
    def send_request
      begin
        response = RestClient.post(PagseguroClient.checkout_url, data, {
          :content_type => "application/x-www-form-urlencoded",
          :charset => "UTF-8"
        })

        parse_response(response.body)

      rescue => e
        raise parse_response(e.response)
      end
    end
  end

  class PagseguroError < StandardError
    attr_reader :code, :message
    def initialize(code, message)
      @code, @message = code, message
    end
  end
end
