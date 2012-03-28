#coding: UTF-8
require 'spec_helper'

describe "admin/managers/index.html.haml" do
 before do
  @list = FactoryGirl.create_list(:manager, 5)
  @login = @list.first
  session[:manager] = @login.id
  assign(:managers, @list)
  render
 end
 #it { rendered.should have_xpath("//a[@href='/admin/managers']") }
 it "should list managers" do
  @list.each{| u | rendered.should have_xpath("//a[@href='/admin/managers/#{u.id}/edit']", :text => u.name) }
 end
end
