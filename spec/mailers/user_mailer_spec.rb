require "rails_helper"

describe UserMailer do
  let!(:user) { create :user }
  after do
    ActionMailer::Base.deliveries = []
  end

  describe ".registration_confirmation" do
    it "sends email for registration confirmation" do
      email = UserMailer.registration_confirmation(user).deliver_now

      expect(ActionMailer::Base.deliveries).to_not be_empty

      expect(email.from).to include("no-reply@dineconnectapp.com")
      expect(email.to).to include(user.email)
      expect(email.subject).to eq("Confirm your email to activate your account")
    end
  end
end
