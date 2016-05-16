class CreateStripeAccount < ActiveRecord::Migration
  def change
    create_table :stripe_accounts do |t|
      t.references :customer, index: true, foreign_key: true
      t.string :publishable_key,              limit: 255
      t.string :secret_key,                   limit: 255
      t.string :stripe_user_id,               limit: 255
      t.string :currency,                     limit: 255
      t.string :stripe_account_type,          limit: 255
      t.text :stripe_account_status,          default: "{}"
    end
  end
end

