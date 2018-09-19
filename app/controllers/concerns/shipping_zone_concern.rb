module ShippingZoneConcern
  extend ActiveSupport::Concern
  include ApplicationConcern
  attr_reader :store

  def get_shipping_zones(store)
    @store = store
    zones = HTTParty.get("https://api.bigcommerce.com/stores/#{@store.bc_hash}/v2/shipping/zones", :headers => create_request_headers(store))
    parse_zones(zones)
  end
  
  def parse_zones(zones)
    store_zone_ids = []
    zones.each do |zone|
      name = zone["name"]
      bc_zone_id = zone["id"]
      store_zone_ids << bc_zone_id
      store_id = store.id
      save_zones_in_concern(name, bc_zone_id, store_id)
    end
    remove_zones_from_db_if_they_no_longer_exist(store_zone_ids)
  end
  
  def remove_zones_from_db_if_they_no_longer_exist(store_zone_ids)
    zones_in_db = store.zones.pluck(:bc_zone_id)
    zones_to_remove = zones_in_db - store_zone_ids
    zones_to_remove.each do |remove|
      current_store.zones.find_by(bc_zone_id: remove).delete
    end
  end
  
  def save_zones_in_concern(name, bc_zone_id, store_id)
    zone_exists = Zone.where(zone_name: name, bc_zone_id: bc_zone_id, store_id: store_id)
    if zone_exists.empty?
      Zone.create(zone_name: name, bc_zone_id: bc_zone_id, store_id: store_id)
    end
  end

end