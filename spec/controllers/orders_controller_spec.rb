require 'spec_helper'

describe OrdersController do
 before do
  @user = FactoryGirl.build(:user)
  #@user = FactoryGirl.build(:user, :ext_hash => '123')
  @user.stub!(:valid?).and_return(true)
  @user.stub!(:create_axapta_account).and_return(true)
  Axapta.stub!(:user_info).and_return({})
  @user.save!
  @account = FactoryGirl.build(:account, :blocked => false, :user => @user)
  @account.save!
  @user.current_account = @user.accounts.first
  @user.save!
  controller.sign_in @user
 end


 describe "GET 'index'" do
  before do
   @orders = [{}]
   Axapta.stub!(:sales_info).and_return(@orders)
  end
  it "should be successful" do
   get 'index'
   response.should be_success
  end

  it "should assign orders" do
   get 'index'
   assigns[:orders].should == @orders
  end
 end

 describe "GET 'show'" do
  before do
   @orders = [{:sales_id => '01'}, {:sales_id => '02'}].map{|s| OpenStruct.new s }
   Axapta.stub!(:sales_lines).and_return([OpenStruct.new({:sales_id => '01'})])
   get 'show', :id => @orders.first.sales_id
  end

  it "should be successful" do
   response.should be_success
  end

  it "should assign order" do
   assigns[:order].should == [@orders.first]
  end
 end

end
