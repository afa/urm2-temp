require 'spec_helper'

describe Account do
 context "new" do
  before do
   User.any_instance.stub!(:valid?).and_return(true)
   Axapta.stub!(:user_info).and_return({})
   @account = FactoryGirl.create(:account)
  end
  specify {@account.should respond_to(:user)}
  specify {@account.should respond_to(:parent)}
  specify {@account.should respond_to(:children)}
 end
end
