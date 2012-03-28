#coding: UTF-8
require 'spec_helper'

describe Account do
 context "new" do
  before do
   User.any_instance.stub(:valid?).and_return(true)
   Axapta.stub!(:user_info).and_return({})
   @account = FactoryGirl.create(:account)
  end
  specify {@account.should respond_to(:user)}
  specify {@account.should respond_to(:parent)}
  specify {@account.should respond_to(:children)}
 end

 context "on renew_structure" do
   let(:ui) { {:blocked => '0', :business => "КОМПЭЛ", :empl_name=>"КАШИНА НАТАЛЬЯ ЛЬВОВНА", :empl_email => 'datis@compel.ru', :contact_email => 'datis@compel.ru', :contact_first_name => 'Владимир', :contact_last_name => 'Ластовка', :contact_middle_name => 'Владимирович', :user_name => 'УРМ-2 Тест' } } #, :user_id => 1
  before do
   @user = FactoryGirl.build(:user)
   @user.stub!(:valid?).and_return(true)
   @user.stub!(:create_axapta_account).and_return(true)
   Axapta.stub!(:user_info).and_return(ui)#, :user_id => 1
   @user.save!
   @account = FactoryGirl.build(:account, :blocked => false, :user => @user)
   @account.save!
   @user.current_account = @user.accounts.first
   @user.save!

   #@account.update_attributes :axapta_user_id => Factory.next(:axapta_user_id)
   #@account = FactoryGirl.create(:account, :user => @user, :axapta_hash => 'asdfg')
   Axapta.stub!(:load_child_hashes).with(@account.axapta_hash).and_return([])
   Axapta.renew_structure(@account.axapta_hash)
  end
  subject { @account }
  it "should reload axapta info" do
   Account.find(@account.id).blocked.should == false
   Account.find(@account.id).business.should == "КОМПЭЛ"
  end
  context "should renew parent" do
   before do
    @puser = FactoryGirl.build(:user)
    @puser.stub!(:valid?).and_return(true)
    @puser.stub!(:create_axapta_account).and_return(true)
    Axapta.stub!(:user_info).and_return(ui)#, :user_id => 1
    @puser.save!
    @prnt = FactoryGirl.build(:account, :blocked => false, :user => @puser)
    @prnt.save!
    @puser.current_account = @puser.accounts.first
    @puser.save!
    @prnt.children << @account
    @account.axapta_parent_id = @prnt.axapta_user_id
    @account.save!
    Axapta.stub!(:user_info).with(@user.current_account.axapta_hash).and_return({})
    Axapta.stub!(:user_info).with(@puser.current_account.axapta_hash).and_return({:business => 'test'})
    Axapta.renew_structure(@user.current_account.axapta_hash)
   end
   it "with hash" do
    Account.find(@prnt.id).business.should == 'test'
   end
  end
  context "should renew children" do
   before do
    @uchld = FactoryGirl.build_list(:user, 2)
    Axapta.stub!(:user_info).and_return(ui)#, :user_id => 1
    @chld = []
    @uchld.each do |u|
     u.stub!(:valid?).and_return(true)
     u.stub!(:create_axapta_account).and_return(true)
     u.save!
     a = FactoryGirl.build(:account, :blocked => false, :user => u)
     a.save!
     u.current_account = u.accounts.first
     u.save!
     @chld << a
     @account.children << a
     a.axapta_parent_id = @account.axapta_user_id
     a.save!
    end
    #@account.children.each{|a| a.axapta_user_id = Factory.next(:axapta_user_id) }
    Axapta.stub!(:user_list).with(@user.current_account.axapta_hash).and_return({})
    #@chld.each{|u| Axapta.stub!(:user_info).with(u.axapta_hash).and_return({:business => 'test'}) }
    Axapta.stub!(:load_child_hashes).with(@user.current_account.axapta_hash).and_return(@user.accounts.first.children.map{|c| {"business" => 'tst', "user_id" => c.axapta_user_id} })
    @chld.each {|c| Axapta.stub!(:user_info).with(c.axapta_hash).and_return(:business => 'tst') }
    Axapta.renew_structure(@user.current_account.axapta_hash)
   end
   it "with hash" do
    @chld.each{|a| Account.find(a.id).business.should == 'tst' }
   end
  end
  it "should renew user tree"
 end
end
