require 'spec_helper'

describe UsersController do

  before do
   User.any_instance.stub(:valid?).and_return(true)
   Axapta.stub!(:user_info).and_return({})
   @parent = FactoryGirl.create(:user)
   @user = FactoryGirl.create(:user, :parent => @parent)
   @chlds = FactoryGirl.create_list(:user, 2, :parent => @user)
   @chlds.each{|u| u.accounts.first.update_attributes :parent_id => @user.accounts.first.id }
   controller.sign_in @user
   @invalid = FactoryGirl.create(:user)
  end

  #let(:user){mock_model(User)}
  describe "GET 'index'" do
   before do
    get :index
   end
    specify { response.should be_success }
    it "should assign @children" do
     assigns[:children].sort_by{|u| u.id}.should == @chlds.sort_by{|u| u.id}
    end
    it "should assign @parent" do
     assigns[:parent].should == @parent
    end
  end

  describe "GET 'show'" do
   before do
    get :show, :id => @user.id
   end
   specify { response.should be_success }
  end

  describe "GET show with @invalid" do
   before do
    get :show, :id => @invalid.id
   end
   specify { response.should be_redirect }
   specify { flash[:error].should_not be_blank }
  end

  describe "GET 'new'" do
   before do
    get 'new'
   end
    specify { response.should be_success }
  end

  describe "GET 'edit'" do
   before do
    get 'edit', :id => @user.id
   end
    specify { response.should be_success }
    specify { assigns[:user].should == @user }
  end

  describe "POST 'create'" do
   it "should be successful" do
    #assigns[:user] = {:user_name => "test", :ext_hash => 'asd'}
    User.any_instance.stub(:valid?).and_return(true)
    User.any_instance.stub(:unique_hash).and_return(true)
    Account.any_instance.stub(:validates_uniqueness_of).and_return(true)
    @hpass = Factory.next(:ext_hash)
    post 'create', :user=>{:username => "test", :ext_hash => @hpass}
    response.should be_success
   end
  end

  describe "PUT 'update'" do
   before do
    @next_hash = Factory.next(:ext_hash)
    @next_name = Factory.next(:username)
   end
   it "should be redirect" do
    #put 'update', :id => @user.id, :user => {:username => @next_name, :ext_hash => @next_hash}
    put 'update', :id => @user.id, :user => {:username => @next_name}
    response.should be_redirect
   end
   it "should update params" do
    put 'update', :id => @user.id, :user => {:username => @next_name}
    User.find(@user.id).username.should == @next_name
    assigns[:accounts].should_not be_blank
   end
  end

#  describe "DELETE 'destroy'" do
#    it "should be successful" do
#      delete 'destroy', :id => user.id
#      response.should be_success
#    end
#  end

end
