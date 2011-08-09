require 'spec_helper'

describe "users/index.html.haml" do
 before do
  User.any_instance.stub(:valid?).and_return(true)
  Axapta.stub!(:user_info).and_return({})
  @parent = FactoryGirl.create(:user)
  @user = FactoryGirl.create(:user, :parent => @parent)
  #@user.stub!(:valid?).and_return(true)
  #@user.save!
  @users = FactoryGirl.build_list(:user, 5)
  #@users.each{|u| u.stub!(:valid?).and_return(true) }
  #@users.each{|u| u.save! }
  assign(:children, @users)
  assign(:parent, @parent)
  session[:user] = @user.id
  render
 end

 it "should render logged user" do
  rendered.should have_content(@user.username)
 end
 it "should render axapta userinfo (account)" do
  @user.accounts.each{|a| rendered.should render_template(:partial => 'accounts/_info', :info => a)}
  #@user.accounts.each{|a| rendered.should have_content(a.axapta_hash)}
 end
 it "should render all managable users (children)" do
  @users.each {|u| rendered.should have_content(u.username) }
 end
 it "should show parent user" do
  rendered.should have_content(@parent.username)
 end
 
 it "should show edit link" do
  rendered.should have_xpath("//a[@href='#{edit_user_path(@user)}']")
 end
end
