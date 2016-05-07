require "rails_helper"

describe User do
  describe "#age" do
    before do
      Timecop.freeze(Date.parse("2016-05-07"))
    end

    after do
      Timecop.return
    end

    let(:user) { build :user, date_of_birth: Date.parse("1989-04-05") }

    it "calculate year between DOB to now" do
      expect(user.age).to eq(27)
    end

    context "DOB is nil" do
      let(:user) { build :user, date_of_birth: nil }

      it "returns 0" do
        expect(user.age).to eq(0)
      end
    end
  end
end
