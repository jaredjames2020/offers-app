class OffersController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def new
    current_user.companies.build
    @user = current_user
    @companies = current_user.companies
    @company = current_user.companies.new
    @travel = Travel.all
    @all_companies = Company.all
    # find_travel
  end

  def index
      if user_signed_in?
        @offers = current_user.companies
        current_user_offers
        # user_route_offers
      else
        @offers = Offer.all
      end
  end

  def create
    @offer = Offer.new(offer_params)
      if @offer.save
        redirect_to travel_path(@offer.travel.id)
      else
        set_travel
        @offer.errors.full_messages
        redirect_to new_travel_offer_path(@travel)
      end
  end

  def show
    @offer = Offer.find(params[:id])
  end

  private

  def offer_params
    params.require(:offer).permit(:description, :travel_id, company_attributes: [:name, :location, :category])
  end

  # def find_travel
  #   @travel = Travel.find(params[:travel_id])
  # end

  def set_travel
    @travel = Travel.find(params[:offer][:travel_id])
  end

  def current_user_offers
    current_user.companies.each do |user_offers|
      user_offers.offers
    end
  end

  # def user_route_offers
  #   @a = []
  #   current_user.companies.select(:id).each do |uuu|
  #     @a << find_travel.offers.select {|o| o.company_id == uuu.id}
  #   end
  #   @a
  # end



end
