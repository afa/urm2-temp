require 'spec_helper'

describe PasswordsController do
 before do
  @user = FactoryGirl.build(:user)
  @user.stub!(:valid?).and_return(true)
  @user.save!
 end

  describe "GET 'new'" do
   it "should be successful" do
    session[:user] = @user.id
    get 'new'
    response.should be_success
   end
  end

#  describe "GET 'index'" do
#   it "should be successful" do
#    get 'index'
#    response.should be_success
#   end
#  end

  describe "POST 'create'" do
   it "should be successful when password valid" do
    session[:user] = @user.id
    post 'create', :user => { :password => 'password' }
    response.should be_success
   end

   it "should regenerate encrypted password"
   it "should send new password to view"
   it "should fail on invalid password"
  end

#  describe "GET 'edit'" do
#    it "should be successful" do
#      get 'edit', :id => @user.id
#      response.should be_success
#    end
#  end

#  describe "PUT 'update'" do
#    it "should be successful" do
#      put 'update', :id => 1
#      response.should be_success
#    end
#  end

end
