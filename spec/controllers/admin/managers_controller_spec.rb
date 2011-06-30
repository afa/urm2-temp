require 'spec_helper'

describe Admin::ManagersController do

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
