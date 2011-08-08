require 'spec_helper'

describe "accounts/new.html.haml" do
 before do
  @user = FactoryGirl.build(:user)
  5.times do
   @user.accounts << FactoryGirl.create(:account, :user => @user)
  end

  @user.stub! :check_axapta_validity
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
 it "should render assigned fields"
 it "should ask for axapta hash"
end
