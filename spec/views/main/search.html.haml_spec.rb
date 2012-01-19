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
  @items = FactoryGirl.build_list(:store, 2)
  #@items = Offer::Store.fabricate([{:item_id => 123, :item_name => 'ttt'}])
  assign(:items, @items)
  assign(:accounts, @login.accounts)
  assign(:current_user, @login)
  assign(:search, OpenStruct.new(:query_string => 'tst'))
  assign(:cart, [])
  #controller.send(:current_user=, @login)
  render
 end
 #no anonymous in view. anon - redirected in controller
 # no extendeds, mv it to search form
 #it "should show ext search form" do
 # rendered.should have_xpath("//form[@action='/extended' and @method='post']")
 # rendered.should have_xpath("//form//input[@name='extended[only_available]' and @type='checkbox']")
 # rendered.should have_xpath("//form//input[@name='extended[invent_location_id]' and @type='text']")
 # rendered.should have_xpath("//form//input[@name='extended[cust_account]' and @type='text']")
 # rendered.should have_xpath("//form//input[@name='extended[query_string]' and @type='text']")
 # rendered.should have_xpath("//form//input[@name='extended[search_brend]' and @type='text']")
 # rendered.should have_xpath("//form//input[@name='extended[item_id_search]' and @type='text']")
 # rendered.should have_xpath("//form//input[@name='extended[calc_qty]' and @type='checkbox']")
 # rendered.should have_xpath("//form//input[@name='extended[show_delivery_prognosis]' and @type='checkbox']")
 # rendered.should have_xpath("//form//input[@name='extended[calc_price]' and @type='checkbox']")
 #end
 it "should render all items" do
  @items.each do |i|
   rendered.should have_xpath("//td", :text => i["item_brend"])
  end
 end
 it "should render cart/cart_table" do
  rendered.should render_template("carts/_cart_table")
 end

 #it "should show link to "
end
