json.array!(@payments) do |payment|
  json.extract! payment, :id, :order_id, :amount, :reference, :confirmed, :refundable, :amount_refunded, :parent_payment_id, :exported
  json.url payment_url(payment, format: :json)
end
