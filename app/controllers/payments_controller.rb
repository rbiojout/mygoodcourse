class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_employee!


  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
  end


  # POST /payments
  # POST /payments.json
  def create
    @order = Order.find(params[:payment][:order_id])
    logger.debug("===> @order #{params[:order_id]} #{@order}")
    @payment = @order.payments.build(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to @payment, notice: t('views.flash_create_message') }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment, notice: t('views.flash_update_message') }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: t('views.flash_delete_message') }
      format.json { head :no_content }
    end
  end

  def refund
    if request.post?
      @payment.refund!(params[:amount])
      redirect_to @order, flash: { notice: 'refunded' }
    else
      render layout: false
    end
  rescue Errors::RefundFailed => e
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
end
