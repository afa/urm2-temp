require 'spec_helper'

describe CartsController do
 before do
  @user = FactoryGirl.build(:user)
  @user.stub!(:valid?).and_return(true)
  Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
  @user.save!
  @accounts = FactoryGirl.create_list(:account, 2, :user => @user)
  @account = @accounts.first
  @user.current_account = @accounts.first
  @user.save!
  @carts = FactoryGirl.create_list(:cart_store, 2, :user => @user, :processed => false, :amount => 1)
  controller.sign_in @user
  User.current.stub!(:deliveries).and_return(["del_id", "del_type"])
 end


  describe "GET 'index'" do
    it "should be successful" do
     # assigns[:carts] = @carts
      get 'index'
      response.should be_success
    end

   it "should setup @cart" do
    #assigns[:carts] = @carts
    get "index"
    assigns[:carts].should be_kind_of(Array)
   end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "should be successful" do
      post 'create', :items => {:commit => 'ok'}
      response.should be_redirect
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => 0
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    it "should be successful" do
      put 'update', :id => 0
      response.should be_success
    end
  end

end
