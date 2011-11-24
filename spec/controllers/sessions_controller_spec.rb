require 'spec_helper'

describe SessionsController do

  before do
  @user = FactoryGirl.build(:user)
  #@user = FactoryGirl.build(:user, :ext_hash => '123')
  @user.stub!(:valid?).and_return(true)
  @user.stub!(:create_axapta_account).and_return(true)
   @pass = "password" #@user.send(:calc_pass)
   @user.stub(:calc_pass).and_return(@pass)
  Axapta.stub!(:user_info).and_return({})
  @user.save!
  @account = FactoryGirl.build(:account, :blocked => false, :user => @user)
  @account.save!
  @user.current_account = @user.accounts.first
  @user.save!
  #controller.sign_in @user

   Axapta.stub!(:user_info).with(@user.current_account.axapta_hash).and_return({})
   @user.save!
   @blocked = Factory.build(:user)
   @blocked.stub!(:valid?).and_return(true)
   @blocked.stub(:calc_pass).and_return(@pass)
   @blocked.stub!(:create_axapta_account).and_return(true)
   #Axapta.stub!(:user_info).with(@blocked.ext_hash).and_return({})
   @blocked.save!
   acc = FactoryGirl.build(:account, :blocked => true, :user => @blocked)
   acc.save!
   @blocked.current_account = @blocked.accounts.first
   @blocked.save!
  end
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
   before do
    controller.sign_out
   end
    it "should be successful" do
     #User.any_instance.stub(:reload_accounts).and_return(nil)
     @user.accounts.each{|a| Axapta.stub!(:renew_structure).with(a.axapta_hash).and_return(true) }
     post 'create', "session" =>{"username" => @user.username, "password" => @pass}
     response.should redirect_to(root_path)
     User.current.should_not be_nil
     #assigns[:current_user].should_not be_nil
    end

   it "should deny blocked user" do
    post 'create', :session => {:username => @blocked.username, :password => @pass}
    #controller.send(:current_user).should be_nil
    User.current.should be_nil
    response.should redirect_to(new_sessions_path)
   end
  end

  describe "DELETE 'destroy'" do
    it "should be successful" do
      controller.sign_in @user
      delete 'destroy'
      response.should be_redirect
      #controller.send(:current_user).should be_nil
      User.current.should be_nil
    end
  end

end
