require 'spec_helper'

describe QuotationsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'lines'" do
    it "returns http success" do
      get 'lines'
      response.should be_success
    end
  end

end
