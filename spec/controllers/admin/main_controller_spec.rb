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
    session[:manager] = manager.id
   end
   let(:manager) { Factory(:manager) }
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

end
