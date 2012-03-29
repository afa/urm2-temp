#coding: UTF-8
require 'spec_helper'

describe "admin/users/edit.html.haml" do
 before do
  Axapta.stub!(:user_info).and_return({})
  @user = FactoryGirl.create(:user)
  assign(:user, @user)
  render
 end
 specify { rendered.should have_xpath("//form[@action='#{admin_user_path(@user)}']") }
 specify { rendered.should have_xpath("//form//input[@type='text' and @name='user[username]' and @value='#{@user.username}']") }
end
