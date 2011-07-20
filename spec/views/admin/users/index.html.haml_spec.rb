require 'spec_helper'

describe "admin/users/index.html.haml" do
 before do
  @users = FactoryGirl.build_list(:user, 5)
  @users.each{|u| u.stub!(:valid?).and_return(true) }
  @users.each{|u| u.save! }
  assign(:users, @users)
  render
 end
 it { rendered.should render_template("admin/users/_list") }
end
