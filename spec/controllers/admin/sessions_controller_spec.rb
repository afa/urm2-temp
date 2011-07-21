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

   describe "POST 'create'" do
    before do
     @manager = FactoryGirl.build(:manager)
     @manager.save!
    end
    it "should be successful" do
     post 'create', :session => {:name => @manager.name, :password => "password"}
     response.should redirect_to(admin_root_path)
     controller.send(:current_user).should be_is_a(Manager)
    end
   end

  end
 end

 describe "logged manager" do
  before do
   @manager = FactoryGirl.build(:manager)
   @manager.save!
   controller.sign_in @manager
  end


  describe "DELETE 'destroy'" do
   it "should be successful" do
    delete 'destroy'
    response.should redirect_to(new_admin_session_path)
    controller.send(:current_user).should be_nil
    cookies[:manager_remember_token].should be_nil
   end
  end
 end
end
