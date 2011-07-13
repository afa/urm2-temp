require 'spec_helper'

describe Manager do
 it { should respond_to(:password) }
 it { should respond_to(:authenticated?) }
 context "when validating" do
  before do
   @man1 = FactoryGirl.create(:manager)
  end
  context "for unique name" do
   context "with duolicate name" do
    subject { FactoryGirl.build :manager, :name => @man1.name }
    it { should_not be_valid }
   end
   subject { FactoryGirl.build :manager }
   it { should be_valid }
  end
 end
 context "when creating new" do
  context "on validation" do
   before do
    @manager = FactoryGirl.build :manager, :password => 'password', :salt => nil
   end
   it "should generate salt" do
    @manager.should be_valid
    @manager.salt.should_not be_blank
   end
  end
  context "on saving" do
   before do
    @manager = FactoryGirl.build :manager, :password => "password"
   end
   it "should prepare encrypted_password" do
    @manager.encrypted_password.should be_blank
    @manager.save.should be
    @manager.encrypted_password.should_not be_blank
   end
  end
  context "when authenticated by password" do
   before do
    @manager = FactoryGirl.build :manager, :password => "password"
    @manager.save!
   end
   subject { @manager }
   it { should be_authenticated('password') }
  end
 end
end
