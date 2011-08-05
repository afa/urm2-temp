require 'spec_helper'

describe "admin/passwords/index.html.haml" do
 before do
  Axapta.stub!(:user_info).and_return({})
  @user = FactoryGirl.create(:user)
  assign(:user, @user)
  assign(:current_user, @user)
  render
 end

 it { rendered.should have_content(@user.username) }
 it { rendered.should have_content(@user.email) }
 it { rendered.should have_content(@user.ext_hash) }
 it { rendered.should have_xpath("//a[@href='#{edit_admin_user_passwords_path(@user)}']") }
end
