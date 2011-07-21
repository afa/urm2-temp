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
    controller.sign_in manager
   end
   let(:manager) { FactoryGirl.create(:manager) }
   let(:p_man) { FactoryGirl.create(:manager) }
   describe "GET 'index'" do
     it "should be successful" do
       get 'index'
       response.should be_success
     end
   end

   describe "GET 'show'" do
     it "should be successful" do
       get 'show', :id => p_man.id
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
    it "should reshow new" do
     post 'create'
     response.should render_template("admin/managers/new")
    end

    context "with allowed params" do
     let(:manager) {FactoryGirl.create(:manager, :super => true)}
     it "should redirect to list" do
      post 'create', :manager => {:name => 'test', :password => 'test'}
      response.should redirect_to(admin_managers_path)
     end
    end
   end

   describe "GET 'edit'" do
     it "should be successful" do
       get 'edit', :id => p_man.id
       response.should be_success
     end
   end

   describe "PUT 'update'" do
    it "should reshow edit" do
     put 'update', :id => p_man.id
     response.should render_template("admin/managers/edit")
    end
    context "with allowed params" do
     let(:manager) {FactoryGirl.create(:manager, :super => true)}
     it "should redirect to list" do
      put 'update', :id => p_man.id, :manager => {:password => 'test'}
      response.should redirect_to(admin_managers_path)
     end
    end
    context "with allowed params for himself" do
     let(:manager) {FactoryGirl.create(:manager, :super => false)}
     it "should redirect to list" do
      put 'update', :id => manager.id, :manager => {:password => 'test'}
      response.should redirect_to(admin_managers_path)
     end
    end
   end
  end
end
