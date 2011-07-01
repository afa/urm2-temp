require 'spec_helper'

describe Admin::PasswordsController do


  describe "unloged get index" do
   it "should be redirect to new session" do
    get :index, :user_id => 0
    response.should redirect_to(new_admin_session_path)
   end
  end
  describe "logged manager" do
   before do
    session[:manager] = manager.id
   end
   let(:manager) { Factory(:manager) }
   describe "GET 'index'" do
     it "should be successful" do
       get 'index', :user_id => 0
       response.should be_success
     end
   end

   describe "GET 'edit'" do
     it "should be successful" do
       get 'edit', :user_id => 0
       response.should be_success
     end
   end

   describe "GET 'update'" do
     it "should be successful" do
       get 'update', :user_id => 0
       response.should be_success
     end
   end
  end
end
