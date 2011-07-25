require 'spec_helper'

describe User do
 before do
  @user = FactoryGirl.build(:user)
  @user.stub!(:valid?).and_return(true)
  @user.save!
 end
# context "new user" do
  specify { @user.should respond_to :accounts}
  specify { @user.should respond_to :parent}
  specify { @user.should respond_to :children}
  specify { @user.should respond_to(:accounts_children) }
  context "#accounts_children" do
   before do
    
   end
   it "should select groupped children"
  end
# end
end
