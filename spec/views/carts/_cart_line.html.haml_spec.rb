#coding: UTF-8
require 'spec_helper'

describe "carts/_cart_line.html.haml" do
 before do
  assign(:cart_line, {})
  render
 end
 it "should render cart_line template"
end
