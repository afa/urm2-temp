#coding: UTF-8
require 'spec_helper'

describe "sessions/new.html.haml" do
 it "should show login form" do
  render
  rendered.should have_xpath("//input[@type='text' and @name='session[username]']")
  rendered.should have_xpath("//input[@type='password' and @name='session[password]']")
  rendered.should have_xpath("//a[@href='#{new_user_path}']")
  #rendered.should have_xpath("//a[@href='#{new_password_path}']")
 end
end
