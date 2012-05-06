require "spec_helper"

module PagseguroClient
  describe Order do

    context "order with id" do
      subject {
        Order.new("ABCDEF")
      }

      its(:id) { should == "ABCDEF" }
    end

    context "order with attributes and products" do
      subject {
        order = Order.new("John Doe")
        order.add(id: "1", description: "Description", amount: 199)
        order
      }

      it "should parse success response xml" do
        xml = <<-XML
          <?xml version="1.0" encoding="ISO-8859-1"?>
          <checkout>
              <code>8CF4BE7DCECEF0F004A6DFA0A8243412</code>
              <date>2010-12-02T10:11:28.000-02:00</date>
          </checkout>
        XML

        hash = subject.parse_response(xml)
        hash[:code].should == "8CF4BE7DCECEF0F004A6DFA0A8243412"
      end

      it "should add product" do
        subject.products.should_not be_empty
        subject.products.size.should == 1
        subject.products.first[:id].should == "1"
      end

      it "should set order product data" do
        subject.add(id: "2", description: "Description", amount: 199)
        subject.add(id: "3", description: "Description", amount: 199)

        data = subject.data
        data.keys.include?("itemId1").should be_true
        data.keys.include?("itemId2").should be_true
        data.keys.include?("itemId3").should be_true

        data["itemId1"].should == "1"
        data["itemId2"].should == "2"
        data["itemId3"].should == "3"
      end
    end

    context "order with invalid product amount" do
      it "should parse error response xml" do
        response_xml = <<-XML
          <?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?><errors><error><code>11029</code><message>Item amount invalid pattern: 30. Must fit the patern: \\d+.\\d{2} </message></error></errors>
        XML

        order = Order.new("XPTO")
        error = order.parse_response(response_xml)
        error.kind_of?(PagseguroError).should be_true
        error.code.should == "11029"
        error.message.should == "Item amount invalid pattern: 30. Must fit the patern: \\d+.\\d{2} "
      end
    end
  end
end
