require 'spec_helper'

describe "main/index.html.haml" do
 before do
 end
 context "for anonymous" do
  before do
   session[:user] = nil
   render
  end
  it "should show link to registration" do
   rendered.should have_xpath("a[@href='#{new_user_path}']")
  end
  it "should show recovery password rules"
  it "should show llogin form"
 end
 context "for registered user" do
  it "should show userlist"
  it "should show link to logout"
 end
end
