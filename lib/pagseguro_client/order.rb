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
      data = {
        email: PagseguroClient.email,
        token: PagseguroClient.token,
        currency: "BRL",
        reference: id
      }
      products.each_with_index do |item, index|
        index += 1
        data["itemId#{index}"] = item[:id]
        data["itemDescription#{index}"] = item[:description]
        data["itemAmount#{index}"] = item[:amount]
        data["itemQuantity#{index}"] = item[:quantity] || 1
      end
      
      data
    end
    
    # Send a new payment request to Pagseguro
    # Returns the URL to redirect your user to complete the payment in Pagseguro
    def send_request
      response = RestClient.post("#{PagseguroClient.base_url}/v2/checkout", data)

      doc = Nokogiri::XML(response.body)
      code = doc.xpath("//code").text

      {
        code: code,
        url: "#{PagseguroClient.base_url}/v2/checkout/payment.html?code=#{code}"
      }
    end
  end
end
