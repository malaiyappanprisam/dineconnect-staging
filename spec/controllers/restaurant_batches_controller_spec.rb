require "rails_helper"

describe RestaurantBatchesController do
  let(:user) { create :user, role: :admin }

  before do
    sign_in_as(user)
  end

  describe "GET /new" do
    it "returns http response :ok" do
      get :new

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    let(:ll) { "-6.214432, 106.813197" }
    let(:radius) { 200 }
    let(:params) { { "latlong" => ll, "radius" => radius.to_s } }

    it "redirect to restaurants" do
      allow(FoursquareImporterJob).to receive(:perform_async)

      post :create, restaurant_batch: { latlong: ll, radius: radius }

      expect(response).to redirect_to(restaurant_batch_path(RestaurantBatch.last.id))
      merged_params = params.merge(batch_id: RestaurantBatch.last.id)
      expect(FoursquareImporterJob).to have_received(:perform_async).with(merged_params)
    end
  end

  describe "GET /show" do
    let!(:restaurant_batch) { create :restaurant_batch }

    it "returns ok" do
      get :show, id: restaurant_batch.id

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
    end
  end
end
