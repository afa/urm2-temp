require 'spec_helper'

describe "admin/main/index.html.haml" do
 before do
  #User.any_instance.stub(:valid?).and_return(true)
  #User.any_instance.stub(:unique_hash).and_return(true)
  Account.any_instance.stub(:validates_uniqueness_of).and_return(true)
  @users = FactoryGirl.build_list(:user, 5, :ext_hash => rand(1000).to_s)
  @users.each do |u|
  u.stub!(:valid?).and_return(true)
  u.stub!(:unique_hash).and_return(true)
  Axapta.stub!(:user_info).with(u.ext_hash).and_return({})
  u.save!
  end
  session[:manager] = FactoryGirl.create(:manager).id
  assign(:users, @users)
  render
 end
 it { rendered.should have_xpath("//a[@href='/admin/managers']") }
 it "should list users" do
  @users.each{| u | rendered.should have_xpath("//a[@href='/admin/users/#{u.id}/passwords/edit']", :text => u.username) }
 end
end
