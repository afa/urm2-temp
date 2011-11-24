require 'spec_helper'

describe "accounts/show.html.haml" do
 before do
  @user = FactoryGirl.build(:user)
  #@user = FactoryGirl.build(:user, :ext_hash => '123')
  @user.stub!(:valid?).and_return(true)
  @user.stub!(:create_axapta_account).and_return(true)
  Axapta.stub!(:user_info).and_return({})
  @user.save!
  @accounts = FactoryGirl.build_list(:account, 5, :blocked => false, :user => @user)
  @accounts.each{|a| a.save!}
  @user.current_account = @user.accounts.first
  @user.save!
  @account = @user.accounts.first
  assign(:user, @user)
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
