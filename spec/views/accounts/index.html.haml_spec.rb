#coding: UTF-8
require 'spec_helper'

describe "accounts/index.html.haml" do
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

  #@user = FactoryGirl.build(:user)
  #5.times do
  # @user.accounts << FactoryGirl.create(:account, :user => @user)
  #end
  
  #@user.stub! :check_axapta_validity
  #@user.save!
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
 it "should show new account link" do
  rendered.should have_xpath("//a[@href='#{new_user_account_path(@user)}']")
 end
end
