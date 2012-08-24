require "spec_helper"

describe "Base" do
  describe "checkout_url" do
    it "should return the pagseguro checkout url" do
      PagseguroClient.checkout_url.should == "#{PagseguroClient.ws_url}/v2/checkout"
    end
  end

  describe "#payment_url" do
    it "should return the pagseguro payment base url with the specified transaction code" do
      PagseguroClient.payment_url("XPTO").should == "#{PagseguroClient.ws_url}/v2/checkout/payment.html?code=XPTO"
    end
  end

  describe "#notification_url" do
    it "should return the pagseguro ws_url base url with specified transaction code" do
      PagseguroClient.notification_url("XPTO").should == "#{PagseguroClient.ws_url}/v2/transactions/notifications/XPTO"
    end
  end

  describe "#redirect_url" do
    it "should return the configured redirect_to URL" do
      PagseguroClient.redirect_url.should == "#{PagseguroClient.redirect_url}"
    end
  end
end
