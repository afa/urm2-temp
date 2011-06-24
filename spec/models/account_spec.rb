require 'spec_helper'

describe Account do
 context "new" do
  let(:account) {Account.new}
  it {account.should respond_to(:user)}
 end
end
