require 'spec_helper'

describe "admin/managers/edit.html.haml" do
 before do
  @manager = FactoryGirl.create(:manager)
  assign(:manager, @manager)
  render
 end
 it { rendered.should have_xpath("//form[@action='/admin/managers/#{@manager.id}']//input[@type='text' and @name='manager[name]']") }
 it { rendered.should have_xpath("//form[@action='/admin/managers/#{@manager.id}']//input[@type='password' and @name='manager[password]']") }
end
