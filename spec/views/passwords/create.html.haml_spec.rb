#coding: UTF-8
require 'spec_helper'

describe "passwords/create.html.haml" do
 before do
  @user = FactoryGirl.build(:user)
  @user.stub!(:valid?).and_return(true)
  @user.stub!(:calc_pass).and_return("check-password")
  Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
  @user.save!
 end
 it "should render generated path" do
  assign(:password, "check-password")
  session[:user] = @user.id
  render
  rendered.should have_content("check-password")
 end
 #TODO:need more?
end
