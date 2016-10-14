class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show]

  before_action :correct_user, only: [:show]

  before_action :authenticate_employee!, only: [:refund]



  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # POST
  def refund
    if request.post?
      @payment.refund!(params[:amount])
      redirect_to @order, flash: { notice: 'refunded' }
    else
      render layout: false
    end
  rescue StandardError => e
    redirect_to @order, flash: { alert: e.message }
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:order_id, :amount, :reference, :confirmed, :refundable, :amount_refunded, :parent_payment_id, :exported)
    end

    def correct_user
      @payment = Payment.find(params[:id])
      redirect_to catalog_products_path, alert: t('dialog.restricted') if @payment.nil? || current_customer.nil? || @payment.order.customer_id != current_customer.id
    end
end
