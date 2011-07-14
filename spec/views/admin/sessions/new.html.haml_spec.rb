require 'spec_helper'

describe "admin/sessions/new.html.haml" do
 before do
  render
 end
 it { response.should have_xpath("//form[@action='/admin/sessions']//input[@type='text' and @name='session[name]']") }
 it { response.should have_xpath("//form[@action='/admin/sessions']//input[@type='password' and @name='session[password]']") }
end

#%h2 Sign in
#- form_for :session, :url => admin_sessions_path do |f|
# .field
#  = f.label :name
#  = f.text_field :name
# .field
#  = f.label :password
#  = f.password_field :password
# .field
#  = f.submit "sign in"

