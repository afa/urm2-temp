require 'spec_helper'

describe PasswordsController do
 before do
  @user = User.new(FactoryGirl.attributes_for(:user))
  @user.stub!(:valid?).and_return(true)
  @user.stub!(:calc_pass).and_return('password')
  Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
  @user.save!
 end

  describe "GET 'new'" do
   it "should be successful" do
    controller.sign_in @user
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
    controller.sign_in @user
    post 'create', :user => { :password => 'password' }
    response.should be_success
   end

   it "should regenerate encrypted password" do
    controller.sign_in @user
    @user.stub!(:calc_pass).and_return('ipassword')
    post 'create', :user => { :password => 'password' }
    assigns["password"].should == 'ipassword'
    assigns["password"].should_not be_blank
   end
   it "should fail on invalid password" do
    controller.sign_in @user
    post 'create', :user => { :password => 'xpassword' }
    response.should render_template(:new)
   end
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
