require 'spec_helper'

describe UsersController do

  before do
   User.any_instance.stub(:valid?).and_return(true)
   Axapta.stub!(:user_info).and_return({})
   @user2 = FactoryGirl.create(:user)
   @user = FactoryGirl.create(:user, :parent => @user2)
   @chlds = FactoryGirl.create_list(:user, 2, :parent => @user)
   @chlds.each{|u| u.accounts.first.update_attributes :parent_id => @user.accounts.first.id }
   session[:user] = @user
  end

  let(:user){mock_model(User)}
  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
    it "should assign @children" do
     get :index
     assigns[:children].sort_by{|u| u.id}.should == @chlds.sort_by{|u| u.id}
    end
    it "should assign @parent" do
     get :index
     assigns[:parent].should == @user2
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :id => user.id
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => user.id
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "should be successful" do
      #assigns[:user] = {:user_name => "test", :ext_hash => 'asd'}
      User.any_instance.stub(:valid?).and_return(true)
      User.any_instance.stub(:unique_hash).and_return(true)
      Account.any_instance.stub(:validates_uniqueness_of).and_return(true)
      post 'create', :user=>{:username => "test", :ext_hash => 'asd'}
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    it "should be successful" do
      put 'update', :id => user.id
      response.should be_success
    end
  end

#  describe "DELETE 'destroy'" do
#    it "should be successful" do
#      delete 'destroy', :id => user.id
#      response.should be_success
#    end
#  end

end
