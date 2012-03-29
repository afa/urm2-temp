#coding: UTF-8
require 'spec_helper'

describe "accounts/edit.html.haml" do
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
