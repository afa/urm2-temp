require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the MainHelper. For example:
#
# describe MainHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe Admin::ApplicationHelper do
 describe "on #current_user" do
  context "when user valid" do
   before do
    @manager = FactoryGirl.build(:manager)
    @manager.stub!(:valid?).and_return(true)
    @manager.save!
    session[:manager] = @manager.id
   end
   it "should locate logged user" do
    current_user.should_not be_nil
    current_user.should == @manager
   end
  end
 end
 describe "on #logged_in?" do
  before do
   @manager = FactoryGirl.build(:manager)
   @manager.stub!(:valid?).and_return(true)
   @manager.save!
   session[:manager] = @manager.id
  end
  context "when valid user" do
   it "say ok" do
    logged_in?.should be_true
   end 
  end
  context "when unknown user" do
   before do
    session[:manager] = 0
   end
   it "say no" do
    logged_in?.should_not be_true
   end
  end
  context "when no user" do
   before do
    session[:manager] = nil
   end
   it "say no" do
    logged_in?.should_not be_true
   end
  end
 end

end

