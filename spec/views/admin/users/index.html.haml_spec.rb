#coding: UTF-8
require 'spec_helper'
include HelperUser

describe "admin/users/index.html.haml" do
 before do
  Axapta.stub!(:user_info).and_return({})
  @users = FactoryGirl.create_list(:user, 5)
  #@users.each{|u| u.stub!(:valid?).and_return(true) }
  #@users.each{|u| u.save! }
  assign(:users, @users)
  render
 end
 it { should render_template("admin/users/_list") }
end
