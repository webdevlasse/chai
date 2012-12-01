class ShopsController < ApplicationController
  # before_filter :authenticate_user!

  # def index
  #   @shops = Shop.all
  # end

  def native_results
    logger.info "--------------------"
    logger.info params
    logger.info "--------------------"
    location = { latitude: params[:latitude], longitude: params[:longitude] }
    box = GeoHelper.bounding_box(location,40)
    # logger.info "--------------------"
    # logger.info box
    # logger.info "--------------------"
    #box = { north_latitude:  ,south_latitude:, east_longitude:, :west_longitude }
    @shops = Shop.where("latitude <= ? AND latitude >= ? AND longitude <= ? AND longitude >= ?",
               box[:north_latitude], box[:south_latitude], box[:east_longitude], box[:west_longitude])

    @shops.map do |shop|
      shop.chai_score = 0 if shop.chai_score.nil?
    end

    @shops.sort_by! {|shop| -1 * shop.chai_score }
    logger.info "--------------------"
    logger.info @shops.all
    logger.info "--------------------"

    render :json => { :html_content => render_to_string('show', :layout => false) , :businesses => @shops }

  end

  def create
    # sends a search query to Yelp via our YelpHelper module
      #check if and where this is being used, if at all
    @search = YelpHelper.query("#{params[:latitude]},#{params[:longitude]}")
    logger.info @search
    # gets the results from our YelpHelper module query
    @results = YelpHelper.search("#{params[:latitude]},#{params[:longitude]}")

    @shops = []
    @results[:businesses].each  do |shop|
      Shop.update_or_create_by_name_and_latitude_and_longitude(shop.except(:distance, :review_count))
      @shops << Shop.update_or_create_by_name_and_latitude_and_longitude(shop.except(:distance, :review_count))
    end

    # @shops.map do |shop|
    #   shop.chai_score = 0 if shop.chai_score.nil?
    # end

    # @shops.sort_by! {|shop| -1 * shop.chai_score }


    render :json => { :html_content => render_to_string('show', :layout => false), :businesses => @results[:businesses], :region =>  @results[:region] }
  end
end
