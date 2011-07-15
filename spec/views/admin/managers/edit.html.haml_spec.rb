require 'spec_helper'

describe "admin/managers/edit.html.haml" do
 before do
  render
 end
 it { rendered.should have_xpath("//form[@action='/admin/managers']//input[@type='text' and @name='manager[name]']") }
 it { rendered.should have_xpath("//form[@action='/admin/managers']//input[@type='password' and @name='manager[password]']") }
end
