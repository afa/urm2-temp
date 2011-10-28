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
   User.any_instance.stub(:valid?).and_return(true)
   Axapta.stub!(:user_info).and_return(ui)#, :user_id => 1
   @user = FactoryGirl.create(:user)
   @account = Account.find_by_axapta_hash(@user.ext_hash)
   @account.update_attributes :axapta_user_id => Factory.next(:axapta_user_id)
   #@account = FactoryGirl.create(:account, :user => @user, :axapta_hash => 'asdfg')
   Axapta.stub!(:load_child_hashes).with(@user.ext_hash).and_return([])
   Axapta.renew_structure(@user.ext_hash)
  end
  subject { @account }
  it "should reload axapta info" do
   Account.find(@account.id).blocked.should == false
   Account.find(@account.id).business.should == "КОМПЭЛ"
  end
  context "should renew parent" do
   before do
    #User.any_instance.stub(:valid?).and_return(true)
    #Axapta.stub(:user_info).with('asdfg').and_return(:blocked => '0', :business => "КОМПЭЛ", :empl_name=>"КАШИНА НАТАЛЬЯ ЛЬВОВНА", :empl_email => 'datis@compel.ru', :contact_email => 'datis@compel.ru', :contact_first_name => 'Владимир', :contact_last_name => 'Ластовка', :contact_middle_name => 'Владимирович', :parent_user_id => '', :user_name => 'УРМ-2 Тест')
    @puser = FactoryGirl.create(:user)
    @prnt = Account.find_by_axapta_hash(@puser.ext_hash)
    @prnt.children << @account
    #@account = FactoryGirl.create(:account, :user => @user, :axapta_hash => 'asdfg')
    @account.axapta_parent_id = @prnt.axapta_user_id
    @account.save!
    Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
    Axapta.stub!(:user_info).with(@puser.ext_hash).and_return({:business => 'test'})
    Axapta.renew_structure(@user.ext_hash)
   end
   it "with hash" do
    Account.find(@prnt.id).business.should == 'test'
   end
  end
  context "should renew children" do
   before do
    #User.any_instance.stub(:valid?).and_return(true)
    #Axapta.stub(:user_info).with('asdfg').and_return(:blocked => '0', :business => "КОМПЭЛ", :empl_name=>"КАШИНА НАТАЛЬЯ ЛЬВОВНА", :empl_email => 'datis@compel.ru', :contact_email => 'datis@compel.ru', :contact_first_name => 'Владимир', :contact_last_name => 'Ластовка', :contact_middle_name => 'Владимирович', :parent_user_id => '', :user_name => 'УРМ-2 Тест')
    @uchld = FactoryGirl.create_list(:user, 2)
    @chld = @uchld.map{|u| Account.find_by_axapta_hash(u.ext_hash)}.uniq
    @account.children << @chld
    @account.children.each{|a| a.axapta_parent_id = @account.axapta_user_id }
    @account.children.each{|a| a.axapta_user_id = Factory.next(:axapta_user_id) }
    @account.children.each{|a| a.save! }
    Axapta.stub!(:user_list).with(@user.ext_hash).and_return({})
    #@chld.each{|u| Axapta.stub!(:user_info).with(u.axapta_hash).and_return({:business => 'test'}) }
    Axapta.stub!(:load_child_hashes).with(@user.ext_hash).and_return(@user.accounts.first.children.map{|c| {"business" => 'tst', "user_id" => c.axapta_user_id} })
    @chld.each {|c| Axapta.stub!(:user_info).with(c.axapta_hash).and_return(:business => 'tst') }
    Axapta.renew_structure(@user.ext_hash)
   end
   it "with hash" do
    @chld.each{|a| Account.find(a.id).business.should == 'tst' }
   end
  end
  it "should renew user tree"
 end
end
