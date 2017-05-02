class Api::V1::CountriesController < API::ApplicationController

  before_action :set_country, only: [:show]

  before_action :authenticate_employee!, except: [:index, :show]

  before_action :transform_params, only: :index

  # GET /countries
  # GET /countries.json
  def index
    countries = Country.all

    render json: countries, each_serializer: CountrySerializer
  end

  # GET /countries/1
  # GET /countries/1.json
  def show
    render json: @country
  end


private

  # Use callbacks to share common setup or constraints between actions.
  def set_country
    @country = Country.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def country_params
    params.require(:country).permit(:name, :code2, :code3, :continent, :tld, :currency, :eu_member)
  end
end
