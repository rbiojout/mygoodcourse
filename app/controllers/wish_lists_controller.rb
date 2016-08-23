class WishListsController < ApplicationController
  before_action :set_product, only: [:wish, :unwish]
  before_action :authenticate_customer!, only: [:wish, :unwish]

  # POST /wish_lists/wish?product_id=
  def wish
    current_customer.wish(@product)
    respond_to do |format|
      format.html {redirect_to current_customer}
      format.js { }
    end
  end

  # DELETE /wish_lists/unwish?product_id=
  def unwish
    current_customer.unwish(@product)
    respond_to do |format|
      format.html {redirect_to current_customer}
      format.js { }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:product_id])
  end

end
