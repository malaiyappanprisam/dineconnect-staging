class FoursquareImporter
  def self.run(ll, radius, batch_id=nil)
    @@client ||= Foursquare2::Client.new(client_id: "XE3XG1VMIFTWIHPTUPGFXAENDSR3WH45ZLRUCYKCH2RGSPCO", client_secret: "GE1O2XN5ME3L0RCRDMDW4Y40A4HPTX1U5DVRIGKSGDCQDTNM", api_version: "20160820")
    ids = @@client.search_venues(ll: ll, intent: "browse", radius: radius, categoryId: %w{4bf58dd8d48988d142941735 4bf58dd8d48988d10c941735 4bf58dd8d48988d110941735 4bf58dd8d48988d1cc941735 4bf58dd8d48988d1d3941735}.join(",")).venues.map { |v| v.id }
    if batch_id.present?
      batch = RestaurantBatch.find(batch_id)
    else
      batch = nil
    end
    ids.map do |id|
      @@client.venue(id)
    end.each do |venue|
      restaurant = Restaurant.find_or_create_by(foursquare_id: venue.id)
      restaurant.open_schedules.delete_all
      restaurant_hash = {
        name: venue.name,
        price: price_category(venue),
        address: venue.location.address,
        location: "#{venue.location.try(:lat)},#{venue.location.try(:lng)}",
        phone_number: venue.contact.try(:phone),
        description: venue.description,
        food_type_ids: food_types(venue),
        open_schedules_attributes: open_schedules(venue.id),
      }
      if venue.location.try(:postalCode).present?
        restaurant_hash = restaurant_hash.merge({
          area: Area.where("digit_of_postal_code LIKE ?", "%#{venue.location.postalCode[0..1]}%").first
        })
      end
      if venue.bestPhoto.present?
        restaurant_hash = restaurant_hash.merge({
          remote_cover_url: [
            venue.bestPhoto.prefix,
            venue.bestPhoto.width, "x", venue.bestPhoto.height,
            venue.bestPhoto.suffix
          ].join("")
        })
      end

      restaurant.update(restaurant_hash)
      if batch.present?
        batch.restaurants << restaurant
      end
    end
    if batch.present?
      batch.update(finished: true)
    end
  # rescue
  #   if batch.present?
  #     batch.update(finished: true)
  #   end
  end

  def self.price_category(venue)
    price_tier = venue.attributes.groups.first.try(:items).try(:first).try(:[], "priceTier").to_i
    if price_tier > 0
      Restaurant.prices.keys[price_tier - 1]
    else
      Restaurant.prices.keys[0]
    end
  end

  def self.food_types(venue)
    venue.categories.map do |category|
      FoodType.find_or_create_by(foursquare_id: category.id) do |food_type|
        food_type.name = category.name
      end.try(:id)
    end
  end

  def self.open_schedules(venue_id)
    @@client.venue_hours(venue_id).popular.timeframes.to_a.flat_map do |timeframe|
      timeframe.open.map do |o|
        {
          day: OpenSchedule.days.keys[timeframe.days.first - 1],
          time_open: o.start.gsub("+", "").insert(2, ":"),
          time_close: o.end.gsub("+", "").insert(2, ":")
        }
      end
    end
  end

  def self.save_to_tempfile(url)
    uri = URI.parse(url)
    file = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      resp = http.get(uri.path)
      extension = Pathname.new(uri.path).extname
      file = Tempfile.new(['foo', extension], Dir.tmpdir)
      file.binmode
      file.write(resp.body)
      file.flush
      file
    end
    file
  end
end
