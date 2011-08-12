require 'spec_helper'

describe "users/update.html.haml" do
 before do
  Account.any_instance.stub(:validates_uniqueness_of).and_return(true)
  @user = FactoryGirl.build(:user, :password => "password")
  @user.stub!(:valid?).and_return(true)
  @user.stub!(:unique_hash).and_return(true)
  Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
  @user.save!
  assign(:current_user, @user)
  assign(:user, @user)
  #session[:user] = @login.id
  render #_template "main/index.html.haml"
 end

 it "should render link to users"
 it "should show axapta_hash"
 it "should render fields"
end
