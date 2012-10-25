require "spec_helper"

describe Employee do
  before do

  end
  describe "feedback" do
    let(:mail) { Employee.feedback }

    it "renders the headers" do
      mail.subject.should eq("Feedback")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
