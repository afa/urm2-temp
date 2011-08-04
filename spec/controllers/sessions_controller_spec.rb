require 'spec_helper'

describe SessionsController do

  before do
   @user = Factory.build(:user, :username => "test", :ext_hash => 'aaa')
   @user.stub!(:valid?).and_return(true)
   @pass = @user.send(:calc_pass)
   @user.stub(:calc_pass).and_return(@pass)
   Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
   @user.save
  end
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "should be successful" do
      post 'create', "session" =>{"name" => @user.username, "password" => @pass}
      response.should redirect_to(root_path)
      controller.send(:current_user).should be_is_a(User)
      #session["user"].should == @user.id
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
