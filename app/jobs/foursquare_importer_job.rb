class FoursquareImporterJob < ActiveJob::Base
  include SuckerPunch::Job
  queue_as :default

  def perform(param_hash)
    latlong = param_hash[:latlong]
    radius = param_hash[:radius]
    batch_id = param_hash[:batch_id]
    FoursquareImporter.run(latlong, radius, batch_id)
  end
end
