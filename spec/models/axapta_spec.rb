require 'spec_helper'

describe Axapta do
 context "on #search_names" do
  it "should return array" do
   AxaptaRequest.stub!(:search_item_name_h).and_return({"items"=>[]})
   Axapta.search_names(:user_hash => 'asd').should be_is_a(Array)
  end
  it "should convert hashes to structs" do
   AxaptaRequest.stub!(:search_item_name_h).and_return({"items"=>[{"item_id" => "tst"}]})
   Axapta.search_names(:user_hash => 'asd').all?{|i| i.is_a?(Hash) }.should be
  end
 end

 context "on #search_analogs" do
  it "should return array" do
   AxaptaRequest.stub!(:search_item_an_h).and_return({"items"=>[]})
   Axapta.search_analogs(:user_hash => 'asd').should be_is_a(Array)
  end
  it "should skip rows with requested item_id (doubles)" do
   AxaptaRequest.stub!(:search_item_an_h).and_return({"items"=>[{"item_id" => "tst"}, {"item_id" => "t2"}]})
   Axapta.search_analogs(:user_hash => 'asd', :item_id_search => "tst").size.should == 1
  end
 end

 context "on #sales_info" do
  before do
   AxaptaRequest.stub!(:sales_info).and_return([{:sales_id => '01'}])
  end

  it "should return array" do
   Axapta.sales_info().should be_is_a(Array)
  end
  it "should return empty array on exception"
  it "should return array of openstructs" do
   Axapta.sales_info().should_not be_empty
   Axapta.sales_info().each{|s| s.should be_is_a(OpenStruct) }
  end
  it "should set sales_id for items"
 end

 context "on #sales_lines" do
  before do
   AxaptaRequest.stub!(:sales_lines).and_return({:sales_id => '01'})
  end
  it "should return openstruct" 
 end

end
