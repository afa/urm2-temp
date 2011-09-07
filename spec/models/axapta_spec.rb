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
end
