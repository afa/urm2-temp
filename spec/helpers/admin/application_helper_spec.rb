require 'spec_helper'

describe Admin::ApplicationHelper do
# before do
#  @user = FactoryGirl.build(:user)
#  5.times do
#   @user.accounts << FactoryGirl.create(:account, :user => @user)
#  end
#
#  @user.stub! :check_axapta_validity
#  @user.save!
#  assign(:user, @user)
#  assign(:accounts, @user.accounts)
#  render
# end

 describe "on #current_user" do
  context "when user valid" do
   before do
    @manager = FactoryGirl.create(:manager)
    assign(:current_user, @manager)
   end
   it "should locate logged user" do
    helper.current_user.should == @manager
   end
  end
 end
 describe "on #logged_in?" do
  before do
   @manager = FactoryGirl.create(:manager)
   assign(:current_user, @manager)
  end
  context "when valid user" do
   it "say ok" do
    helper.logged_in?.should be
   end 
  end
#  context "when unknown user" do
#   before do
#    assign(:current_user, 0)
#   end
#   it "say no" do
#    helper.logged_in?.should_not be_true
#   end
#  end
  context "when no user" do
   before do
    assign(:current_user, nil)
   end
   it "say no" do
    helper.logged_in?.should_not be_true
   end
  end
 end

end

