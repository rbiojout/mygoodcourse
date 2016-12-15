class PeersController < ApplicationController
  before_action :set_followed, only: [:follow, :unfollow]
  before_action :authenticate_customer!, only: [:follow, :unfollow]

  # POST /peers/follow?followed_id=
  def follow
    current_customer.follow(@followed)
    respond_to do |format|
      format.html { redirect_to current_customer }
      format.js {}
    end
  end

  # DELETE /peers/unfollow?followed_id=
  def unfollow
    current_customer.unfollow(@followed)
    respond_to do |format|
      format.html { redirect_to current_customer }
      format.js {}
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_followed
    @followed = Customer.find(params[:followed_id])
  end
end
