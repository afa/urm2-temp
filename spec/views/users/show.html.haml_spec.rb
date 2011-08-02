require 'spec_helper'

describe "users/show.html.haml" do
 before do
  @user =FactoryGirl.build(:user)
  @user.stub!(:valid?).and_return(true)
  Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
  @user.save!
  assign(:user, @user)
  render
 end
 it "should render user name" do
  rendered.should have_content(@user.username)
 end
 it "should render user name"
end
