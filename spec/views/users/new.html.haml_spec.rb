require 'spec_helper'

describe "users/new.html.haml" do
 before do
  #Account.any_instance.stub(:validates_uniqueness_of).and_return(true)
  @login = FactoryGirl.build(:user)
  #@login.stub!(:valid?).and_return(true)
  #@login.stub!(:unique_hash).and_return(true)
  #@login.save!
  assign(:user, @login)
  #session[:user] = @login.id
  render
 end
 it "should show registration form" do
  rendered.should have_xpath("//form[@action='#{users_path}' and @method='post']")
 end
 it "should show username field" do
  rendered.should have_xpath("//input[@name='user[username]' and @type='text']")
 end
 it "should show ext_hash field" do
  rendered.should have_xpath("//input[@name='user[ext_hash]' and @type='text']")
 end
end
