#coding: UTF-8
require 'spec_helper'

describe "carts/_cart_table.html.haml" do
 before do
  assign(:cart, [])
  render
 end
 it "should render cart_table template"
end
