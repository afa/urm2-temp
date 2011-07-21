require 'spec_helper'

describe "admin/users/show.html.haml" do
 before do
  Axapta.stub!(:user_info).and_return({})
  @user = FactoryGirl.create(:user)
  assign(:user, @user)
  render
 end
 specify { rendered.should have_content(@user.username) }
 specify { rendered.should have_xpath("//a[@href='#{edit_admin_user_path(@user)}']") }
end
