require "spec_helper"

describe PagseguroClient::Order do
  
  it "should set order id when instantiating object" do
    order = PagseguroClient::Order.new("ABCDEF")
    order.id.should == "ABCDEF"
  end
  
  it "should add product" do
    order = PagseguroClient::Order.new("John Doe")
    order.add(id: "1", description: "Description", amount: 199)
    order.products.should_not be_empty
    order.products.size.should == 1
    order.products.first[:id].should == "1"
  end
  
  it "should set order product data" do
    order = PagseguroClient::Order.new("John Doe")
    order.add(id: "1", description: "Description", amount: 199)
    order.add(id: "2", description: "Description", amount: 199)
    order.add(id: "3", description: "Description", amount: 199)
    
    data = order.data
    data.keys.include?("itemId1").should be_true
    data.keys.include?("itemId2").should be_true
    data.keys.include?("itemId3").should be_true
    
    data["itemId1"].should == "1"
    data["itemId2"].should == "2"
    data["itemId3"].should == "3"
  end
  
end
