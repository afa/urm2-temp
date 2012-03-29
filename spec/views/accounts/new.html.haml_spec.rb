#coding: UTF-8
require 'spec_helper'

describe "accounts/new.html.haml" do
 before do
  @user = FactoryGirl.build(:user)
  @user.stub!(:valid?).and_return(true)
  Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
  @user.save!
  @accounts = FactoryGirl.create_list(:account, 5, :user => @user)
  @account = @accounts.first
  @user.current_account = @accounts.first
  @user.save!

  assign(:user, @user)
  #assign(:accounts, @user.accounts)
  assign(:account, account)
  render
 end
 let(:account) { @user.accounts.new }
 it "should render form" do
  rendered.should have_xpath("//form[@action='#{user_accounts_path(@user)}']")
 end
 it "should render assigned fields" do
  #rendered.should have_xpath("//form//input[@type='text' and @name='account[contact_first_name]']")
  #rendered.should have_xpath("//form//input[@type='text' and @name='account[contact_middle]']")
  #rendered.should have_xpath("//form//input[@type='text' and @name='account[contact_last_name]']")
 end
 it "should ask for axapta hash" do
  rendered.should have_xpath("//form//input[@type='text' and @name='account[axapta_hash]']")
 end
end
