require 'spec_helper'

describe "passwords/new.html.haml" do
 before do
  @login = FactoryGirl.build(:user)
  @login.stub!(:valid?).and_return(true)
  Axapta.stub!(:user_info).with(@login.ext_hash).and_return({})
  @login.save!
  assign(:user, @login)
  render
 end
 it "should render current password field" do
  rendered.should have_xpath("//input[@type='password']")
 end
 it "should render check password form" do
  rendered.should have_xpath("//form[@action='#{passwords_path}']")
 end
end
