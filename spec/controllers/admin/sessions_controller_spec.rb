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

   context "post create" do
    context "without params" do
     it "should deny" do
      post "create"
      response.should redirect_to(new_admin_session_path)
     end
    end
   end
  end

  describe "logged manager" do
   before do
    @manager = FactoryGirl.create(:manager)
    cookies[:manager_remember_token] = {
          :value   => @manager.remember_token,
          :expires => 1.year.from_now.utc
        }
   end


   describe "POST 'create'" do
     it "should be successful" do
       post 'create', :session => {:name => @manager.name, :password => "password"}
       response.should redirect_to(admin_root_path)
       controller.send(:current_user).should be_is_a(Manager)
     end
   end

   describe "DELETE 'destroy'" do
     it "should be successful" do
       delete 'destroy'
       response.should redirect_to(new_admin_session_path)
       assigns["current_user"].should be_nil
       controller.send(:current_user).should be_nil
       #session[:manager].should be_nil
     end
   end
  end
end
