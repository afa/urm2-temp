require 'spec_helper'

describe "admin/sessions/new.html.haml" do
 before do
  render
 end
 it { rendered.should have_xpath("//form[@action='/admin/sessions']//input[@type='text' and @name='session[name]']") }
 it { rendered.should have_xpath("//form[@action='/admin/sessions']//input[@type='password' and @name='session[password]']") }
end
