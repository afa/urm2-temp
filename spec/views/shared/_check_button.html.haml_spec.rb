#coding: UTF-8
require 'spec_helper'

describe "shared/_check_button.html.haml" do
 it "should display named/titled span withowt opts" do
  render :partial => "shared/check_button", :locals => {:name => "test", :title => "titletest"}
  rendered.should have_xpath('//span[@class="switch check"]')
  rendered.should have_xpath('//span[@class="switch check"]//a[@name="test"]')
  rendered.should have_xpath('//span[@class="switch check"]//span', :text => "titletest")
 end

 context "opts => need_field" do
  it ""
  context "opts => field_code" do

  end
  context "opts => field_opts" do

  end
 end

 context "opts => value" do
  it "should render input with value(true)" do
   render :partial => "shared/check_button", :locals => {:name => "tes-t[123][4]", :title => "titletest", :opts => {:value => true, :need_field => true}}
   rendered.should have_xpath('//span[@class="switch check"]//input[@type="hidden" and @name="tes-t[123][4]" and @id="tes_t_123_4" and @value="1"]')
  end

  it "should render input with value(1)" do
   render :partial => "shared/check_button", :locals => {:name => "tes-t[123][4]", :title => "titletest", :opts => {:value => true, :need_field => 1}}
   rendered.should have_xpath('//span[@class="switch check"]//input[@type="hidden" and @name="tes-t[123][4]" and @id="tes_t_123_4" and @value="1"]')
  end
 end
 
 context "opts => use_system=true" do
  context "opts => id" do
   it "should render input with id" do
    render :partial => "shared/check_button", :locals => {:name => "tes-t[123][4]", :title => "titletest", :opts => {:id => "try_test", :use_system => true}}
    rendered.should have_xpath('//span[@class="switch check"]//input[@type="checkbox" and @name="tes-t[123][4]" and @id="try_test"]')
    rendered.should have_xpath('//span[@class="switch check"]//label[@for="try_test"]', :text => "titletest")
   end

  end

  context "without opts => id" do
   it "should render input with mangled name as id" do
    render :partial => "shared/check_button", :locals => {:name => "tes-t[123][4]", :title => "titletest", :opts => {:use_system => true}}
    rendered.should have_xpath('//span[@class="switch check"]//input[@type="checkbox" and @name="tes-t[123][4]" and @id="tes_t_123_4"]')
    rendered.should have_xpath('//span[@class="switch check"]//label[@for="tes_t_123_4"]', :text => "titletest")
   end
  end

  it "should render checkbox with label" do
   render :partial => "shared/check_button", :locals => {:name => "test", :title => "titletest", :opts => {:use_system => true}}
   rendered.should have_xpath('//span[@class="switch check"]')
   rendered.should have_xpath('//span[@class="switch check"]//input[@type="checkbox" and @name="test" and @id="test"]')
   rendered.should have_xpath('//span[@class="switch check"]//label[@for="test"]', :text => "titletest")
  end
 end
end

=begin
%span.switch.check
 - if defined?(opts)
  - id = opts[:id].blank? ? name.to_s.split(/[\[\]\-]/).compact.join('_') : opts[:id]
  - val = opts.has_key?(:value) ? (opts[:value] ? '1' : '0') : '0'
  - if opts[:use_system]
   %input{:type => "check", :id => id, :value => val, :name => name}
   %label{:for => id}= title
  - else
   - if opts[:need_field]
    - if opts.has_key?(:field_code)
     = opts[:field_code]
    - else
     = hidden_field_tag name, val, opts[:field_opts] || {}
   %a{:href=>"#", :name => name, :class => [opts[:value] == true || opts[:value] == '1' ? "active" : nil]}
    %span= title
 - else
  %a{:href=>"#", :name => name}
   %span= title
=end
