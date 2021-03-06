require 'spec_helper'

describe Admin::UsersController do

  describe "unloged get index" do
   before do
    controller.sign_out
   end
   it "should be redirect to new session" do
    get :index
    response.should redirect_to(new_admin_session_path)
   end
  end
  describe "logged manager" do
   before do
    controller.sign_in manager
    @users = FactoryGirl.build_list(:user, 5)
    Axapta.stub!(:user_info).and_return({})
    @users.each do |user|
     user.stub!(:valid?).and_return(true)
     user.stub!(:create_axapta_account).and_return(true)
     user.save!
     FactoryGirl.create(:account, :blocked => false, :user => user)
     user.current_account = user.accounts.first
     user.save!
    end
    @user = @users.first
   end
   let(:manager) { Factory(:manager) }



   describe "GET 'index'" do
    before do
     get 'index'
    end
    it "should be successful" do
     response.should be_success
    end
    
    specify { @users.each {|u| assigns[:users].should include(u)} }
   end

   describe "GET 'show'" do
    before do
     get 'show', :id => @user.id
    end
    it "should be successful" do
     response.should be_success
    end
    specify { assigns[:user].should eq @user }
   end

   describe "GET 'edit'" do
    before do
     get 'edit', :id => @user.id
    end
    it "should be successful" do
     response.should be_success
    end
    specify { assigns[:user].should eq @user }
   end

   describe "PUT 'update'" do
    before do
     put 'update', :id => @user.id
    end
    it "should be successful" do
     response.should be_redirect
    end
    specify { assigns[:user].should eq @user }
   end
  end
end
