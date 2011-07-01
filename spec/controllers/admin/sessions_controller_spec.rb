require 'spec_helper'

describe Admin::SessionsController do


  describe "unloged" do
   describe "GET 'new'" do
     it "should be successful" do
       get 'new'
       response.should be_success
     end
   end

   it "should be redirect to new session on delete" do
    delete :destroy
    response.should redirect_to(new_admin_session_path)
   end
  end
  describe "logged manager" do
   before do
    session[:manager] = manager.id
   end
   let(:manager) { Factory(:manager) }


   describe "POST 'create'" do
     it "should be successful" do
       post 'create'
       response.should be_success
     end
   end

   describe "DELETE 'destroy'" do
     it "should be successful" do
       delete 'destroy'
       response.should be_success
     end
   end
  end
end
