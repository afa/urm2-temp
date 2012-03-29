#coding: UTF-8
module HelperUser
 def prepare_user(args)
  prepare_user_account(args, {})
 end

 def prepare_user_account(uhash, ahash)
  user = FactoryGirl.build(:user, uhash)
  user.stub!(:valid?).and_return(true)
  user.stub!(:create_axapta_account).and_return(true)
  Axapta.stub!(:user_info).and_return({})
  #TODO: fix axapta user_info
  user.save!
  FactoryGirl.create(:account, {:user => user}.merge(ahash))
  user.current_account = user.accounts.first
  user.save!
  user
 end

 def prepare_user_list(cnt, *args)
  chlds = FactoryGirl.build_list(:user, cnt, *args)
  chlds.each do |c|
   c.stub!(:valid?).and_return(true)
   FactoryGirl.create(:account, :user => c)
   c.save!
   c.current_account = c.accounts.first
   c.save!
  end
  chlds
 end
=begin
   @parent = FactoryGirl.build(:user)
   @parent.stub!(:valid?).and_return(true)
   @parent.stub!(:create_axapta_account).and_return(true)
   @parent.save!
   FactoryGirl.create(:account, :blocked => false, :user => @parent)
   @parent.current_account = @parent.accounts.first
   @parent.save!
   @user = FactoryGirl.build(:user, :parent => @parent)
   @user.stub!(:valid?).and_return(true)
   @user.stub!(:create_axapta_account).and_return(true)
   Axapta.stub!(:user_info).and_return({})
   @user.save!
   FactoryGirl.create(:account, :blocked => false, :user => @user)
   @user.current_account = @user.accounts.first
   @user.save!
=end
end
