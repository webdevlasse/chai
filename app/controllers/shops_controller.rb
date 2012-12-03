class ShopsController < ApplicationController

  # def index
  #   @shops = Shop.all
  # end

  def native_results
    @shops = Shop.fetch_results_by_location(params)
    render :json => { :html_content => render_to_string('show', :layout => false) , :businesses => @shops }
  end

  def create
    #sends a search query to Yelp via our YelpHelper module
    #check if and where this is being used, if at all
    @search = YelpHelper.query("#{params[:latitude]},#{params[:longitude]}")
    logger.info @search

    # gets the results from our YelpHelper module query
    @results = YelpHelper.search("#{params[:latitude]},#{params[:longitude]}")

    @results[:businesses].each  do |shop|
      Shop.update_or_create_by_name_and_latitude_and_longitude(shop.except(:distance, :review_count))
    end

    @shops = Shop.fetch_results_by_location(params)

    render :json => { :html_content => render_to_string('show', :layout => false) , :businesses => @shops }
  end
end
