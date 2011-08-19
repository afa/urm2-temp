require 'spec_helper'

describe "users/edit.html.haml" do
 before do
  @user =FactoryGirl.build(:user)
  @user.stub!(:valid?).and_return(true)
  Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
  @user.save!
  @account = @user.accounts.first
  @account = FactoryGirl.create(:account) unless @account
  @user.accounts << @account if @user.accounts.empty?
  @account.save!
  assign(:user, @user)
  render
 end
 it "should render form" do
  rendered.should have_xpath("//form[@action='#{user_path(@user)}']")
 end
 it "should render fields" do
  rendered.should have_xpath("//form//input[@name='user[username]' and @value='#{@user.username}']")
  rendered.should have_xpath("//form//input[@name='user[email]' and @value='#{@user.email}']")
 end
 it "should render link to change password" do
  rendered.should have_link(:change_password, :href => new_password_path)
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
