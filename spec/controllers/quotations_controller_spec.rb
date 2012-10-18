require 'spec_helper'

describe QuotationsController do
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
  FactoryGirl.create(:setting, :hashed_value, :named, :name => "hash.quotation_status", :value => YAML.dump({1=>'tst'}))
  FactoryGirl.create(:setting, :hashed_value, :named, :name => "hash.quotation_status_ru", :value => YAML.dump({1=>'tst.ru'}))
 end


  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get :show
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
