#geo_helper




module GeoHelper

  # # PI = 3.1415926535
  # RAD_PER_DEG = 0.017453293  #  PI/180

  # # the great circle distance d will be in whatever units R is in

  # Rmiles = 3956           # radius of the great circle in miles
  # Rkm = 6371              # radius in kilometers...some algorithms use 6367
  # Rfeet = Rmiles * 5282   # radius in feet
  # Rmeters = Rkm * 1000    # radius in meters

  def self.bounding_box(location, distance = 1)
    #distance here should be in km
    #latT = Math.asin( Math.sin( location[:latitude] ) / Math.cos( Rkm ) )
    rkm = 6371.0 # radius in kilometers...some algorithms use 6367
    #delta_latitude = Math.asin( Math.sin( distance / rkm ) / Math.cos( location[:latitude] ) )

    latitude_min = location[:latitude].to_f - ( distance / rkm / 2 ) * 180 / 3.14159265
    latitude_max = location[:latitude].to_f + ( distance / rkm / 2 ) * 180 / 3.14159265

    delta_longitude = Math.asin( Math.sin( distance / rkm ) / Math.cos( location[:latitude].to_f ) ).abs * 180 / 3.14159265

    longitude_min = location[:longitude].to_f - delta_longitude / 2
    longitude_max = location[:longitude].to_f + delta_longitude / 2


    #dlon = Math.acos( Math.cos( distance / Rkm ) - Math.sin(latT) * Math.sin(lat) ) / ( Math.cos(latT) * Math.cos(lat) )


    #37.788022,-122.399797"
    box = {north_latitude: latitude_max  ,south_latitude: latitude_min, east_longitude: longitude_max, west_longitude: longitude_min }
  end

end