require 'spec_helper'

describe User do
 before do
  @user = FactoryGirl.build(:user)
  @user.stub!(:valid?).and_return(true)
  Axapta.stub!(:user_info).with(@user.ext_hash).and_return({})
  @user.save!
 end
# context "new user" do
  specify { @user.should respond_to :accounts}
  specify { @user.should respond_to :parent}
  specify { @user.should respond_to :children}
  specify { @user.should respond_to(:accounts_children) }
  context "#accounts_children" do
   before do
    Axapta.stub!(:user_info).and_return({})
    User.any_instance.stub(:valid?).and_return(true)
    @accounts = FactoryGirl.create_list(:account, 5, :user => @user)
    @accounts.first.children << FactoryGirl.create_list(:account, 2)
    @accounts.last.children << FactoryGirl.create_list(:account, 2)
   end
   specify{ @user.accounts_children.should be_is_a Hash }
   specify{ @user.axapta_children.compact.sort_by{|u| u.id}.should == @user.accounts.map(&:children).flatten.map(&:user).compact.uniq.sort_by{|u| u.id} }
  end
# end

  it "should validate current_account"

 describe "#make_order" do
  before do
   @carts = [FactoryGirl.create(:cart_world, :user_id => @user.id), FactoryGirl.create(:cart_store, :user_id => @user.id)]
   Axapta.stub!(:make_order).and_return(2)
  end
  it "should make order for carts" do
   @user.make_order.should == 2
  end
 end
end
