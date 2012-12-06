class ShopsController < ApplicationController

  # def index
  #   @shops = Shop.all
  # end

  def native_results
    @shops = Shop.fetch_results_by_location( params )
    # @shops = Shop.fetch_by_location(params[:latitude], params[:longitude])
    # checks for the results from the database and calls 'create' when less than 5
    create if @shops.length < 5

    @markers_info = []

    @shops.map do |shop|
      shop.chai_score = 0 if shop.chai_score.nil?
    end

    @shops.sort_by! { |shop| -1 * shop.chai_score }

    @markers_info = @shops.collect { |shop| render_to_string(shop, :layout => false) }

    render :json => { :html_content => render_to_string( :partial => 'list_results',
                                                         :layout => false,
                                                         :locals => { :shops => @shops } ),
                      :businesses => @shops,
                      :html_marker_info => @markers_info }
  end

  def show
    @shop = Shop.find( params[:id] )
    @visit = @shop.visits.build
  end

  def create
    @shops = Shop.fetch_results_by_location(params)

    #sends a search query to Yelp via our YelpHelper module
    #check if and where this is being used, if at all
    @search = YelpHelper.query("#{params[:latitude]},#{params[:longitude]}")
    logger.info @search

    # gets the results from our YelpHelper module query
    @results = YelpHelper.search("#{params[:latitude]},#{params[:longitude]}")

    @results[:businesses].each  do |shop|
      Shop.update_or_create_by_name_and_latitude_and_longitude(shop.except(:distance, :review_count))
    end

    @markers_info = []

    @shops.map do |shop|
      shop.chai_score = 0 if shop.chai_score.nil?
    end

    @shops.sort_by! { |shop| -1 * shop.chai_score }

    @shops.each do |shop|
      @markers_info << render_to_string(:partial => 'marker_info', :layout => false, :object => shop)
    end

    render :json => { :html_content => render_to_string( :partial => 'list_results',
                                                         :layout => false,
                                                         :locals => { :shops => @shops } ),
                      :businesses => @shops,
                      :html_marker_info => @markers_info }

  end
end