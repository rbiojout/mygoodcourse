class CreateStripeCards < ActiveRecord::Migration
  def change
    create_table :stripe_customers do |t|
      t.string :stripe_id
      t.integer :account_balance
      t.string :currency
      t.boolean :delinquent, default: false
      t.references :customer, index: true, foreign_key: true

      t.timestamps null: false
    end

    create_table :stripe_cards do |t|
      t.string :stripe_id
      t.string :name
      t.string :brand
      t.integer :exp_month
      t.integer :exp_year
      t.integer :last4
      t.string :country
      t.boolean :default_source, default: false
      t.references :stripe_customer, index: true, foreign_key: true

      t.timestamps null: false
    end


  end
end
