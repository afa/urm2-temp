require 'spec_helper'

describe "admin/managers/show.html.haml" do
 before do
  @login = FactoryGirl.create(:manager)
  @manager = FactoryGirl.create(:manager)
  User.current = @manager
  #assign(:manager, @manager)
 end
 context "when login super" do
  before do
   @superlogin = FactoryGirl.create(:manager, :super => true)
   User.current = @superlogin
   #assign(:current_user, @superlogin)
   render
  end
  it "should render super" do
   rendered.should have_content("Супер")
  end
  it "should render kink to new manager" do
   rendered.should have_xpath("//a[@href='#{new_admin_manager_path}']")
  end
 end
 context "when logged" do
  before do
   #assign(:current_user, @login)
   User.current = @login
   render
  end
  it "should render name" do
   rendered.should have_content(@manager.name)
  end
  it "should render link to edit" do
   rendered.should have_xpath("//a[@href='#{edit_admin_manager_path(@manager)}']")
  end
  it "should render link to users list" do
   rendered.should have_xpath("//a[@href='#{admin_users_path}']")
  end
 end
end
