require 'rails_helper'

describe OpenSchedule do
  it { should belong_to(:restaurant) }

  describe "validations" do
    it { should validate_presence_of(:time_open) }
    it { should validate_presence_of(:time_close) }
    it { should allow_values("23:30", "00:30").for(:time_open) }
    it { should_not allow_values("24:30", "25:30").for(:time_open) }
    it { should allow_values("23:30", "00:30").for(:time_close) }
    it { should_not allow_values("24:30", "25:30").for(:time_close) }
  end
end
