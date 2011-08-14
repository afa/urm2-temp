require 'spec_helper'

describe SessionsController do

  before do
   @user = Factory.build(:user)
   @user.stub!(:valid?).and_return(true)
   @pass = "password" #@user.send(:calc_pass)
   @user.stub(:calc_pass).and_return(@pass)
   Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
   @user.save!
   @blocked = Factory.build(:user)
   @blocked.stub!(:valid?).and_return(true)
   @blocked.stub(:calc_pass).and_return(@pass)
   Axapta.stub!(:user_info).with(@blocked.ext_hash).and_return({})
   @blocked.save!
   @blocked.accounts.each{|a| a.blocked = true; a.save! }
  end
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "should be successful" do
      post 'create', "session" =>{"username" => @user.username, "password" => @pass}
      response.should redirect_to(root_path)
      assigns[:current_user].should_not be_nil
    end

   it "should deny blocked user" do
    post 'create', :session => {:username => @blocked.username, :password => @pass}
    controller.send(:current_user).should be_nil
    response.should redirect_to(new_sessions_path)
   end
  end

  describe "DELETE 'destroy'" do
    it "should be successful" do
      controller.sign_in @user
      delete 'destroy'
      response.should be_redirect
      controller.send(:current_user).should be_nil
    end
  end

end
