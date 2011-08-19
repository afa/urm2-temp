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
  assign(:accounts, @user.accounts)
  render
 end

 it "should render link to users" do
  rendered.should have_xpath("//a[@href='#{users_path}']")
 end

 it "should render fields" do
  rendered.should have_content(@user.username)
  rendered.should have_content(@user.email)
 end

 it "should show accounts info" do
  @user.accounts.each do |a|
   rendered.should have_content(a.contact_first_name)
   rendered.should have_content(a.contact_middle_name)
   rendered.should have_content(a.contact_last_name)
   rendered.should have_content(a.contact_email)
   rendered.should have_content(a.name)
   rendered.should have_content(a.blocked? ? t(:account_blocked) : t(:account_active))
  end
 end

end
