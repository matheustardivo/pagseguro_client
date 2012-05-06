require "spec_helper"

module PagseguroClient
  describe Notification do
    context "parse notification xml" do
      subject {
        Notification.create_by_xml(File.read("spec/support/notification.xml"))
      }

      # attr_accessor :code, :order_id, :status, :payment_method
      its(:code) { should == "9E884542-81B3-4419-9A75-BCC6FB495EF1" }
      its(:order_id) { should == "REF1234" }
      its(:status) { should == :approved }
      its(:payment_method) { should == :credit_card }
    end
  end
end
