module GeoHelper

  def self.bounding_box(location, distance = 1)
    rkm = 6371.0 # radius in kilometers...some algorithms use 6367

    latitude_min = location[:latitude].to_f - ( distance / rkm / 2 ) * 180 / 3.14159265
    latitude_max = location[:latitude].to_f + ( distance / rkm / 2 ) * 180 / 3.14159265

    delta_longitude = Math.asin( Math.sin( distance / rkm ) / Math.cos( location[:latitude].to_f ) ).abs * 180 / 3.14159265

    longitude_min = location[:longitude].to_f - delta_longitude / 2
    longitude_max = location[:longitude].to_f + delta_longitude / 2

    box = {north_latitude: latitude_max  ,south_latitude: latitude_min, east_longitude: longitude_max, west_longitude: longitude_min }
  end

end