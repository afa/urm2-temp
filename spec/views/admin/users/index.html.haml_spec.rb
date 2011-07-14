require 'spec_helper'

describe "admin/users/index.html.haml" do
 before do
  render
 end
 it { rendered.should render_template("admin/users/_list") }
end
