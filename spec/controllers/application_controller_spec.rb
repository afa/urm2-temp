require "spec_helper"

describe ApplicationController do
 before do
  @user = FactoryGirl.build(:user)
  #@user = FactoryGirl.build(:user, :ext_hash => '123')
  @user.stub!(:valid?).and_return(true)
  @user.stub!(:create_axapta_account).and_return(true)
  Axapta.stub!(:user_info).and_return({})
  @user.save!
  @account = FactoryGirl.build(:account, :blocked => false, :user => @user)
  @account.save!
  @user.current_account = @user.accounts.first
  @user.save!
  controller.sign_in @user
 end

 specify { controller.should be_respond_to(:current_user) }
 it "should define accounts" do
  controller.should be_respond_to(:get_accounts)
  controller.send(:get_accounts)
  assigns[:accounts].should_not be_nil
  assigns[:accounts].should be_respond_to(:length)
  assigns[:accounts].should_not be_empty
 end
end
