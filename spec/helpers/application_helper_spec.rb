require 'spec_helper'

describe ApplicationHelper do
 describe "current_user" do
  context "when user valid" do
   before do
    @user = FactoryGirl.build(:user, :ext_hash => 'aaa')
    @user.stub!(:valid?).and_return(true)
    @user.stub!(:create_axapta_account).and_return(true)
    @user.save!
    User.current = @user
    #session[:user] = @user.id
   end
   it "should locate logged user" do
    current_user.should_not be_nil
    current_user.should == @user
   end
  end
 end
 describe "logged_in?" do
 end

end

