require 'spec_helper'

describe Admin::PasswordsController do

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
