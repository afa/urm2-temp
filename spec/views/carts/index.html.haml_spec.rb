#coding: UTF-8
require 'spec_helper'

describe "carts/index.html.haml" do
 before do
  assign(:cart, [])
  render
 end
 it "should render cart_table template" do
  should render_template("carts/_cart_table")
 end
end
