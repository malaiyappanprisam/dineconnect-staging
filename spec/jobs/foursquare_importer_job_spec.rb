require 'rails_helper'

describe FoursquareImporterJob do
  let(:ll) { "-6.214432, 106.813197" }
  let(:radius) { 200 }
  let(:batch) { create :restaurant_batch }
  let(:params) { { latlong: ll, radius: radius, batch_id: batch.id } }

  it "calls FoursquareImporter" do
    allow(FoursquareImporter).to receive(:run)

    FoursquareImporterJob.perform_now(params)

    expect(FoursquareImporter).to have_received(:run).with(ll, radius, batch.id)
  end
end
