require 'spec_helper'

describe "users/index.html.haml" do
 before do
  @user = FactoryGirl.build(:user)
  @user.stub!(:valid?).and_return(true)
  @user.save!
  @users = FactoryGirl.build_list(:user, 5)
  @users.each{|u| u.stub!(:valid?).and_return(true) }
  @users.each{|u| u.save! }
  assign(:users, @users)
  session[:user] = @user.id
  render
 end

 it "should render logged user" do
  rendered.should have_content(@user.username)
 end
 it "should render axapta userinfo (account)"
 it "should render all managable users (children)"
 it "should show parent user"
 
 it "should show edit link"
end
