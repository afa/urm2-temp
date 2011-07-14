require 'spec_helper'

describe Admin::ManagersController do


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

   describe "GET 'new'" do
     it "should be successful" do
       get 'new'
       response.should be_success
     end
   end

   describe "POST 'create'" do
     it "should be successful" do
       post 'create'
       response.should render_template("/admin/managers/new")
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
       response.should be_redirected
     end
   end
  end
end
