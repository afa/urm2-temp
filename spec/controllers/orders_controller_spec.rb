require 'spec_helper'

describe OrdersController do
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


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :id => 0
      response.should be_success
    end
  end

end
