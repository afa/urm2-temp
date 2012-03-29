#coding: UTF-8
require 'spec_helper'

describe "admin/passwords/edit.html.haml" do
 before do
  Axapta.stub!(:user_info).and_return({})
  @user = FactoryGirl.create(:user)
  assign(:user, @user)
  render
 end
 it { rendered.should have_xpath("//form[@action='#{admin_user_passwords_path(@user)}']") }
 it { rendered.should have_xpath("//form//input[@type='checkbox' and @name='password[confirmed]']") }
end
