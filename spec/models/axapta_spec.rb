require 'spec_helper'

describe Axapta do
 context "on #search_names" do
  it "should return array" do
   AxaptaRequest.stub!(:search_item_name_h).and_return({"items"=>[]})
   Axapta.search_names(:user_hash => 'asd').should be_is_a(Array)
  end
  it "should convert hashes to structs" do
   AxaptaRequest.stub!(:search_item_name_h).and_return({"items"=>[]})
   Axapta.search_names(:user_hash => 'asd').all?{|i| i.is_a?(Hash) }.should be
  end
 end
end
