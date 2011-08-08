require 'spec_helper'

describe "main/search.html.haml" do
 before do
  #Account.any_instance.stub(:validates_uniqueness_of).and_return(true)
  @login = FactoryGirl.build(:user)
  @login.stub!(:valid?).and_return(true)
  Axapta.stub!(:user_info).with(@login.ext_hash).and_return({})
  #@login.stub!(:unique_hash).and_return(true)
  Axapta.stub!(:user_info).with(@login.ext_hash).and_return({})
  @login.save!
  assign(:items, [])
  assign(:accounts, @login.accounts)
  assign(:current_user, @login)
  #controller.send(:current_user=, @login)
  render
 end
 #no anonymous in view. anon - redirected in controller
 it "should show link to logout" do
  rendered.should have_xpath("//a[@href='/sessions' and @data-method='delete']")
 end

 it "should show fast search form" do
  rendered.should have_xpath("//form[@action='/search' and @method='post']")
  rendered.should have_xpath("//form//input[@type='text' and @name='search[query]']")
 end

 it "should show ext search form" do
  rendered.should have_xpath("//form[@action='/extended' and @method='post']")
  rendered.should have_xpath("//form//input[@name='extended[only_available]' and @type='checkbox']")
  rendered.should have_xpath("//form//input[@name='extended[invent_location_id]' and @type='text']")
  rendered.should have_xpath("//form//input[@name='extended[cust_account]' and @type='text']")
  rendered.should have_xpath("//form//input[@name='extended[query_string]' and @type='text']")
  rendered.should have_xpath("//form//input[@name='extended[search_brend]' and @type='text']")
  rendered.should have_xpath("//form//input[@name='extended[item_id_search]' and @type='text']")
  rendered.should have_xpath("//form//input[@name='extended[calc_qty]' and @type='checkbox']")
  rendered.should have_xpath("//form//input[@name='extended[user_hash]' and @type='text']")
  rendered.should have_xpath("//form//input[@name='extended[show_delivery_prognosis]' and @type='checkbox']")
  rendered.should have_xpath("//form//input[@name='extended[calc_price]' and @type='checkbox']")
 end
 it "should show account selection form" do
  rendered.should have_xpath("//select[@name='hash']")
 end
 it "should show render all items" 
 #it "should show link to "
end
