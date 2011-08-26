require "spec_helper"

describe "layouts/application.html.haml" do
 before do
  @login = FactoryGirl.build(:user)
  @login.stub!(:valid?).and_return(true)
  Axapta.stub!(:user_info).with(@login.ext_hash).and_return({})
  #@login.stub!(:unique_hash).and_return(true)
  Axapta.stub!(:user_info).with(@login.ext_hash).and_return({})
  @login.save!
  @items = [{:item_id => 123, :item_name => 'ttt'}]
  assign(:items, @items)
  assign(:accounts, @login.accounts)
  assign(:current_user, @login)
  #controller.send(:current_user=, @login)
  render
 end
 it "should show account selection form" do
  rendered.should have_xpath("//select[@name='current_account[account]']")
 end

 it "should show link to logout" do
  rendered.should have_xpath("//a[@href='/sessions' and @data-method='delete']")
 end
end
