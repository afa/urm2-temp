require 'spec_helper'

describe "accounts/edit.html.haml" do
 before do
  @user = FactoryGirl.build(:user)
  5.times do
   @user.accounts << FactoryGirl.create(:account, :user => @user)
  end

  @user.stub! :check_axapta_validity
  @user.save!
  @account = @user.accounts.first
  assign(:user, @user)
  #assign(:accounts, @user.accounts)
  assign(:account, @account)
  render
 end

 it "should render form" do
  rendered.should have_xpath("//form[@action='#{user_account_path(@user, @account)}']")
 end
 it "should render contact" do
  rendered.should have_xpath("//form//input[@type='text' and @name='account[contact_first_name]' and @value='#{@account.contact_first_name}']")
  rendered.should have_xpath("//form//input[@type='text' and @name='account[contact_middle_name]' and @value='#{@account.contact_middle_name}']")
  rendered.should have_xpath("//form//input[@type='text' and @name='account[contact_last_name]' and @value='#{@account.contact_last_name}']")
 end
 it "should render disabled axapta_hash" do
  rendered.should have_xpath("//form//input[@type='text' and @name='account[axapta_hash]' and @value='#{@account.axapta_hash}' and @disabled]")
 end
end
