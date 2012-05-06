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
  end
end
