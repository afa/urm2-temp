require 'spec_helper'

describe SessionsController do

  before do
   User.any_instance.stub(:valid?).and_return(true)
   @user = Factory.build(:user, :username => "test", :ext_hash => 'aaa')
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

  describe "GET 'create'" do
    it "should be successful" do
      post 'create', "session" =>{"username" => @user.username, "password" => @pass}
      response.should redirect_to(root_path)
      session["user"].should == @user.id
    end
  end

  describe "DELETE 'destroy'" do
    it "should be successful" do
      session["user"] = @user.id
      delete 'destroy'
      response.should be_redirect
      session["user"].should be_nil
    end
  end

end
