require 'spec_helper'

describe "main/index.html.haml" do
 before do
  Account.any_instance.stub(:validates_uniqueness_of).and_return(true)
  @list = FactoryGirl.build_list(:user, 5)
  @list.each{|u| u.stub!(:valid?).and_return(true) }
  @list.each{|u| u.stub!(:unique_hash).and_return(true) }
  @list.each{|u| Axapta.stub!(:user_info).with(u.ext_hash).and_return({}) }
  @list.each{|u| u.save! }
  @login = @list.first
  assign(:users, @list)
  session[:user] = @login.id
  assign(:accounts, @login.accounts)
  render #_template "main/index.html.haml"
 end
 #no anonymous in view. anon - redirected in controller
 it "should show userlist" do
  @list.each{|u| rendered.should have_xpath("//a[@href='#{edit_user_path(u)}']", :text => u.username) }
 end

 it "should show search form" do
  rendered.should have_xpath("//form[@action='/search' and @method='post']")
  rendered.should have_xpath("//form//input[@type='text' and @name='search[query_string]']")
 end
end
