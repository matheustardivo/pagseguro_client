require "spec_helper"

describe "Base" do
  it "should return the payment url" do
    PagseguroClient.payment_url("XPTO").should == "#{PagseguroClient.ws_url}/v2/checkout/payment.html?code=XPTO"
  end

  it "should return the notification url" do
    PagseguroClient.notification_url("XPTO").should == "#{PagseguroClient.ws_url}/v2/transactions/notifications/XPTO"
  end
end
