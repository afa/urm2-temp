require 'spec_helper'

describe "admin/users/index.html.haml" do
 before do
  render
 end
 it { response.should render_template("admin/users/_list") }
end
