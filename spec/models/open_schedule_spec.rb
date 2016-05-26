require 'rails_helper'

describe OpenSchedule do
  it { should belong_to(:restaurant) }

  describe "validations" do
    it do
      should validate_numericality_of(:hour_open).
        is_greater_than_or_equal_to(0).
        is_less_than_or_equal_to(23)
    end

    it do
      should validate_numericality_of(:hour_close).
        is_greater_than_or_equal_to(0).
        is_less_than_or_equal_to(23)
    end

    context "hour_close is less than hour_open" do
      subject { described_class.new(hour_close: 1, hour_open: 2) }

      it "invalid" do
        expect(subject).not_to be_valid
        expect(subject.errors[:hour_close]).to include("can't be less than hour open")
      end
    end
  end
end
