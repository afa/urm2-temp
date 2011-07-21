require 'spec_helper'

describe Admin::MainController do

  describe "unloged get index" do
   it "should be redirect to new session" do
    get :index
    response.should redirect_to(new_admin_session_path)
   end
  end
  describe "GET 'index'" do
   before do
    controller.sign_in manager
    #session[:manager] = manager.id
    @ulist = FactoryGirl.build_list(:user, 5)
    @ulist.each{|u| u.stub!(:check_axapta_validity).and_return(true) }
    @ulist.each{|u| u.stub!(:create_axapta_account).and_return(true) }
    @ulist.each {|u| u.save! }
   end
   let(:manager) { Factory(:manager) }
   it "should be successful" do
    get 'index'
    response.should be_success
   end
   it "should prepare users list" do
    get "index"
    assigns["users"].should_not be_empty
    @ulist.each {|u| assigns["users"].should include(u) }
   end
  end

end
