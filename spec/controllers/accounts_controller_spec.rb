require 'spec_helper'

describe AccountsController do
 before do
  @login = FactoryGirl.build(:user)
  @accounts = FactoryGirl.create_list(:account, 5, :user => user)
  @login.stub!(:valid?).and_return(true)
  Axapta.stub!(:user_info).with(@login.ext_hash).and_return({})
  @login.save!
  session[:user] = @login.id
 end
 let(:user){mock_model(User)}
 let(:account){ FactoryGirl.create(:account, :user => user) }
  describe "GET 'index'" do
    it "should be successful" do
      #Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
      get 'index', :user_id => user.id
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :user_id => account.user.id, :id => account.id
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new', :user_id => account.user.id
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :user_id => account.user.id, :id => account.id
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "should be successful" do
      post 'create', :user_id => account.user.id, :id => account.id
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    it "should be successful" do
      put 'update', :user_id => account.user.id, :id => account.id
      response.should be_success
    end
  end

  describe "DELETE 'destroy'" do
    it "should be successful" do
      delete 'destroy', :user_id => account.user.id, :id => account.id
      response.should be_success
    end
  end

end
