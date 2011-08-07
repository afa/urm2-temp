require 'spec_helper'

describe "accounts/index.html.haml" do
 before do
  @user = FactoryGirl.build(:user)
  5.times do
   @user.accounts << FactoryGirl.create(:account, :user => @user)
  end
  
  @user.stub! :check_axapta_validity
  @user.save!
  assign(:user, @user)
  assign(:accounts, @user.accounts)
  render
 end
 it "should show current user accounts list" do
  @user.accounts.each {|a| rendered.should have_content(a.axapta_hash) }
 end
 it "should show edit link to each account" do
  @user.accounts.each {|a| rendered.should have_xpath("//a[@href='#{edit_user_account_path(a.user, a)}']") }
 end
 it "should show name of each account" do
  @user.accounts.each {|a| rendered.should have_content([a.contact_first_name, a.contact_middle_name, a.contact_last_name, ].compact.join(' ')) }
 end
end
