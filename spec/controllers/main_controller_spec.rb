require 'spec_helper'

describe MainController do
 before do
  @user = FactoryGirl.build(:user, :ext_hash => '123')
  @user.stub!(:valid?).and_return(true)
  Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
  @user.save!
  session[:user] = @user
 end

 describe "GET 'index'" do
  it "should be successful" do
   get 'index'
   response.should be_success
  end
 end

 describe "POST 'search'" do
  before do
   post "search", :search => {:query => '21'}
  end
  it "should be success" do
   response.should be_success
  end

  it "should assign items" do
   assigns[:items].should be_kind_of Array
  end
 end
end
