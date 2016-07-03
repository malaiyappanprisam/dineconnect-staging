require "rails_helper"

describe PhotosController do
  let(:user) { create :user, role: :admin }

  before do
    sign_in_as(user)
  end

  let(:file) { Refile::FileDouble.new("dummy", "logo.jpg", content_type: "image/jpg") }
  let!(:restaurant) { create :restaurant, photos_files: [ file ] }
  describe "DELETE /destroy.json" do
    it "redirect to restaurant path" do
      delete :destroy, id: restaurant.photos.first.id, restaurant_id: restaurant.id

      expect(response).to redirect_to(restaurant_path(restaurant))
    end
  end
end
