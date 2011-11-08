require 'spec_helper'

describe CartRequest do
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
 end
 describe "#type_name" do
  it "should be request" do
   CartRequest.new.type_name.should == 'Запрос'
  end
 end
 describe "#offers(count)" do
  it "should return search_names from axapta"
 end
 describe "::prepare_for(count, hash)" do
  before do
   @hsh = {"locations" => [{"vend_qty" => 3}]}
  end
  it "should call CartStore::prepare_for in case" do
   CartStore.stub!(:prepare_for).with(1, @hsh).and_return(:type_name=>"CartStore")
   CartRequest.prepare_for(1, @hsh).should be_is_a(Hash)
   CartRequest.prepare_for(1, @hsh)[:type_name].should == "CartStore"
  end
 end
  pending "add some examples to (or delete) #{__FILE__}"
end

=begin
  def type_name
   ::I18n::t :cart_request
  end

  def offers(count) #ret hash product
   Axapta.search_names(:calc_price => true, :calc_qty => true, :show_delivery_prognosis => true, :item_id_search => product_link, :invent_location_id => location_link, :user_hash => User.current.current_account.axapta_hash)
  end

  def self.prepare_for(count, hsh)
   return CartStore.prepare_for(count, hsh) if !hsh.blank? and count <= hsh["locations"].first["vend_qty"]
   p hsh, count
   {:type => self.name, :amount => count, :product_link => hsh["item_id"], :location_link => hsh["locations"].first["location_id"], :product_name => hsh["item_name"], :product_rohs => hsh["rohs"], :product_brend => hsh["item_brend"], :processed => false, :current_price => 0, :quantity => hsh["qty_in_pack"], :min_amount => hsh["min_qty"], :max_amount => hsh["locations"].first["vend_qty"], :avail_amount => hsh["locations"].first["vend_qty"], :draft => !(count > 0)}
  end
=end
