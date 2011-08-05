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
 end
 it "should show current user accounts list" do
  @user.accounts.each {|a| rendered.should have_content(a.axapta_hash) }
 end
 it "should show edit link to each account"
 it "should show name of each account"
end
