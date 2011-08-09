require 'spec_helper'

describe "accounts/show.html.haml" do
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

 it "should show account axapta hash" do
  rendered.should have_content(@account.axapta_hash)
 end

 it "should show link to edit" do
  rendered.should have_xpath("//a[@href='#{edit_user_account_path(@user, @account)}']")
 end
end
