require 'spec_helper'

describe "users/show.html.haml" do
 before do
  @user =FactoryGirl.build(:user)
  @user.stub!(:valid?).and_return(true)
  Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
  @user.save!
  assign(:user, @user)
  render
 end
 it "should render user name" do
  rendered.should have_content(@user.username)
 end
 it "should render edit link" do
  rendered.should have_xpath("//a[@href='#{edit_user_path(@user)}']")
 end
 it "should render accounts" do
  @user.accounts.each {|a| rendered.should have_content(a.axapta_hash) }
 end
end
