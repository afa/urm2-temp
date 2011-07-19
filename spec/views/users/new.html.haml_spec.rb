require 'spec_helper'

describe "users/new.html.haml" do
 before do
  Account.any_instance.stub(:validates_uniqueness_of).and_return(true)
  @list = FactoryGirl.build_list(:user, 5)
  @list.each{|u| u.stub!(:valid?).and_return(true) }
  @list.each{|u| u.stub!(:unique_hash).and_return(true) }
  @list.each{|u| u.save! }
  @login = @list.first
  #assign(:users, @list)
  #session[:user] = @login.id
 end
 it "should show registration form"
 it "should show username field"
 it "should show ext_hash field"
end
