#coding: UTF-8
require 'spec_helper'

describe "users/create.html.haml" do
 before do
  Account.any_instance.stub(:validates_uniqueness_of).and_return(true)
  @user = FactoryGirl.build(:user, :password => "password")
  @user.stub!(:valid?).and_return(true)
  @user.stub!(:unique_hash).and_return(true)
  Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
  @user.save!
  assign(:user, @user)
  #session[:user] = @login.id
  render #_template "main/index.html.haml"
 end
 it "should show uname" do
  rendered.should have_content(@user.username)
 end
 it "should show generated password" do
  rendered.should have_content("password")
 end
end
