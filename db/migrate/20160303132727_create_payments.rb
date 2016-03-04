class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :order, index: true, foreign_key: true
      t.decimal :amount
      t.string :reference
      t.boolean :confirmed
      t.boolean :refundable
      t.decimal :amount_refunded
      t.integer :parent_payment_id
      t.boolean :exported

      t.timestamps null: false
    end
  end
end
