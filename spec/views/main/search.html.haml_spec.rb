require 'spec_helper'

describe "main/search.html.haml" do
 before do
  #Account.any_instance.stub(:validates_uniqueness_of).and_return(true)
  @login = FactoryGirl.build(:user)
  @login.stub!(:valid?).and_return(true)
  #@login.stub!(:unique_hash).and_return(true)
  Axapta.stub!(:user_info).with(@login.ext_hash).and_return({})
  @login.save!
  assign(:items, [])
  session[:user] = @login.id
  render
 end
 #no anonymous in view. anon - redirected in controller
 it "should show link to logout" do
  rendered.should have_xpath("//a[@href='/sessions' and @data-method='delete']")
 end

 it "should show search form" do
  rendered.should have_xpath("//form[@action='/search' and @method='post']")
  rendered.should have_xpath("//form//input[@type='text' and @name='search[query]']")
 end
end
