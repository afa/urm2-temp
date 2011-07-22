require 'spec_helper'

describe "admin/passwords/update.html.haml" do
 before do
  Axapta.stub!(:user_info).and_return({})
  @user = FactoryGirl.create(:user)
  assign(:user, @user)
  render
 end
 it { rendered.should have_content(@user.password) }
end
