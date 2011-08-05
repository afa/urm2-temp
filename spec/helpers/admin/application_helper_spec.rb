require 'spec_helper'

describe Admin::ApplicationHelper do
 describe "on #current_user" do
  context "when user valid" do
   before do
    @manager = FactoryGirl.build(:manager)
    @manager.stub!(:valid?).and_return(true)
    @manager.save!
    assigns[:current_user] = @manager
    #session[:manager] = @manager.id
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
   assigns[:current_user] = @manager
   #session[:manager] = @manager.id
  end
  context "when valid user" do
   it "say ok" do
    logged_in?.should be_true
   end 
  end
  context "when unknown user" do
   before do
    assigns[:current_user] = 0
    #session[:manager] = 0
   end
   it "say no" do
    logged_in?.should_not be_true
   end
  end
  context "when no user" do
   before do
    assigns[:current_user] = nil
    #controller.sign_out
    #session[:manager] = nil
   end
   it "say no" do
    logged_in?.should_not be_true
   end
  end
 end

end

