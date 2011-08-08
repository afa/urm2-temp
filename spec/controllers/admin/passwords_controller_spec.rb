require 'spec_helper'

describe Admin::PasswordsController do
 before do
  Axapta.stub!(:user_info).and_return({})
  @user = FactoryGirl.build(:user)
  @user.save!
 end

  describe "unloged get index" do
   it "should be redirect to new session" do
    get :index, :user_id => @user.id
    response.should redirect_to(new_admin_session_path)
   end
  end
  describe "logged manager" do
   before do
    controller.sign_in manager
   end
   let(:manager) { Factory(:manager) }
   describe "GET 'index'" do
     it "should be successful" do
       get 'index', :user_id => @user.id
       response.should be_success
     end
   end

   describe "GET 'edit'" do
     it "should be successful" do
       get 'edit', :user_id => @user.id
       response.should be_success
     end
   end

   describe "PUT 'update'" do
    context "when confirmed" do
     it "should be successful" do
       put 'update', :user_id => @user.id
       response.should be_redirect
     end
    end

    context "when nonconfirmed" do
     it "should redirect" do
      put 'update', :user_id => @user.id, :password => {:confirmed => true}
      response.should be_success
     end
    end
   end
  end
end
