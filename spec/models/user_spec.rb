require 'spec_helper'

describe User do
 context "new user" do
  subject {User.new}
  it {should respond_to :accounts}
 end
end
