require 'spec_helper'

describe AccountsController do
 before do
  @login = FactoryGirl.build(:user)
  @login.stub!(:valid?).and_return(true)
  Axapta.stub!(:user_info).with(@login.ext_hash).and_return({})
  @login.save!
  @accounts = FactoryGirl.create_list(:account, 5, :user => @login)
  @account = @accounts.first
  controller.sign_in @login
 end
 #let(:user){mock_model(User)}
 #let(:user) {FactoryGirl.create(:user)}
 #let(:account){ FactoryGirl.create(:account, :user => @login) }
  describe "GET 'index'" do
    it "should be successful" do
      #Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
      get 'index', :user_id => @login.id
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :user_id => @account.user.id, :id => @account.id
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new', :user_id => @account.user.id
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :user_id => @account.user.id, :id => @account.id
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "should be successful" do
      post 'create', :user_id => @account.user.id, :id => @account.id, :account => {:axapta_hash => Factory.next(:ext_hash)}
      response.should be_redirect
    end
  end

  describe "PUT 'update'" do
    it "should be successful" do
      put 'update', :user_id => @account.user.id, :id => @account.id, :account => {:contact_first_name => "#{@account.contact_first_name}+"}
      response.should be_redirect
    end
  end

  describe "DELETE 'destroy'" do
    it "should be redirect" do
      delete 'destroy', :user_id => @account.user.id, :id => @account.id
      response.should be_redirect
    end
    it "should destroy account" do
      delete 'destroy', :user_id => @account.user.id, :id => @account.id
      Account.find_by_id(@account.id).should be_nil
    end
  end

end
