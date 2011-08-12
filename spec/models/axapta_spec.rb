require 'spec_helper'

describe Axapta do
 context "on #search_names" do
  it "should return array" do
   Axapta.search_names().should be_is_a(Array)
  end
  it "should convert hashes to structs"
 end
end
