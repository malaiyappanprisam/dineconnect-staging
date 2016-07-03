require "rails_helper"

describe FoodTypePolicy do
  subject { described_class.new(user, food_type) }

  let(:user) { User.create }
  let(:food_type) { FoodType.create }

  context "being a user" do
    it { is_expected.to forbid_action(:index) }
    it { is_expected.to forbid_action(:new) }
    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:edit) }
    it { is_expected.to forbid_action(:reset_password) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context "being an admin" do
    let(:user) { User.create role: :admin }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:reset_password) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end
end
