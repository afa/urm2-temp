#coding: UTF-8
require "spec_helper"

describe "admin/users/_list.html.haml" do
 before do
  Axapta.stub!(:user_info).and_return({})
  @users = FactoryGirl.create_list(:user, 5)
  #@users.each{|u| u.stub!(:valid?).and_return(true) }
  #@users.each{|u| u.save! }
  render :partial => "admin/users/list", :locals => {:users => @users}
 end
 it { rendered.should have_content(@users.first.username) }
end
