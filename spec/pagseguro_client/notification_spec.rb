#encoding: utf-8
require "spec_helper"

module PagseguroClient
  describe Transaction do
    context "parse transaction xml" do
      subject {
        Transaction.create_by_xml(File.read("spec/support/notification.xml"))
      }
      
      its(:code) { should == "9E884542-81B3-4419-9A75-BCC6FB495EF1" }
      its(:order_id) { should == "REF1234" }
      its(:status) { should == :approved }
      its(:payment_method) { should == :credit_card }
      its(:last_event_date) { should == '2011-02-15T17:39:14.000-03:00' }
      its(:sender) {
        should == { name: 'José Comprador', email: 'comprador@uol.com.br', phone: { area_code: '11', number: '56273440'}}
      }
    end
  end
end
