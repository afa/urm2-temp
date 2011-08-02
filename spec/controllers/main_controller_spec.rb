require 'spec_helper'

describe MainController do

  describe "GET 'index'" do
    before do
     @user = FactoryGirl.build(:user, :ext_hash => '123')
     @user.stub!(:valid?).and_return(true)
     Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
     @user.save!
     session[:user] = @user
    end
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

end
