require 'spec_helper'

describe Admin::UsersController do

  describe "unloged get index" do
   it "should be redirect to new session" do
    get :index
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
       get 'index'
       response.should be_success
     end
   end

   describe "GET 'show'" do
     it "should be successful" do
       get 'show', :id => 0
       response.should be_success
     end
   end

   describe "GET 'edit'" do
     it "should be successful" do
       get 'edit', :id => 0
       response.should be_success
     end
   end

   describe "PUT 'update'" do
     it "should be successful" do
       put 'update', :id => 0
       response.should be_success
     end
   end
  end
end
