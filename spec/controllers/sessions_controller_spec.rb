require 'spec_helper'

describe SessionsController do
 #before do
 # @login = FactoryGirl.build(:user)
 # @accounts = FactoryGirl.create_list(:account, 5, :user => user)
 # @login.stub!(:valid?).and_return(true)
 # Axapta.stub!(:user_info).with(@login.ext_hash).and_return({})
 # @login.save!
 # controller.sign_in @login
 #end


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
   @blocked.accounts.each{|a| a.update_attributes :blocked => true }
   @blocked.save!
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
      #controller.send(:current_user).should be_is_a(User)
      #session["user"].should == @user.id
    end

   it "should deny blocked user" do
    post 'create', :session => {:username => @blocked.username, :password => @pass}
    response.should redirect_to(new_session_path)
    controller.send(:current_user).should be_nil
   end
  end

  describe "DELETE 'destroy'" do
    it "should be successful" do
      controller.sign_in @user
      #session["user"] = @user.id
      delete 'destroy'
      response.should be_redirect
      #session["user"].should be_nil
      controller.send(:current_user).should be_nil
    end
  end

end
