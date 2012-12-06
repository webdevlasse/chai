class Shop < ActiveRecord::Base
  attr_accessible :name, :latitude, :longitude, :rating, :yelp_url,
   :img_url, :address, :city, :state_code, :postal_code, :country_code, :phone
  has_many :visits
  validates :name, :uniqueness => { :scope => [:latitude , :longitude] }
  default_scope order("chai_score DESC")

  # make sure that the default chai_score value is set to 0 instead of nil when entered in DB


  def calculate_chai_score
      visits.average("wifi+power+atmosphere").to_f / 3
  end

# checks for the shops chai rating and if it's nil changes it to zero
  def calculate_and_save_chai_score
    # check if it's even possible for coffeeshop to have nil?
    # could become just "update chai_score"
    score = calculate_chai_score
    score.nil? ? (self.chai_score = 0) : (self.chai_score = score)
    self.save
  end


  def self.update_or_create_by_name_and_latitude_and_longitude(params)
    name, long, lat = params.delete(:name), params.delete(:latitude), params.delete(:longitude)
    shop = self.find_or_create_by_name_and_latitude_and_longitude(name, long, lat)
    shop.update_attributes(params)
    shop
  end


  def self.fetch_results_by_location(params)
    location = { latitude: params[:latitude], longitude: params[:longitude] }
    box = GeoHelper.bounding_box(location,1)
    shops = Shop.where("latitude <= ? AND latitude >= ? AND longitude <= ? AND longitude >= ?",
               box[:north_latitude], box[:south_latitude], box[:east_longitude], box[:west_longitude])
  end

  def self.fetch_by_location(latitude, longitude)
    shops = find_by_location(latitude, longitude)
    shops = find_yelp_shops unless shops.length > 5
    # find records by lat & long
    # search yelp if there are less than 5 results
  end

  def self.find_yelp_shops(latitude, longitude)
    shops = YelpHelper.find(latitude, longitude)
  end
end

