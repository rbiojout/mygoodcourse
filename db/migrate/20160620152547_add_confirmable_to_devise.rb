# rails g migration add_confirmable_to_devise
class AddConfirmableToDevise < ActiveRecord::Migration
  def self.up
    add_column :customers, :confirmation_token, :string
    add_column :customers, :confirmed_at,       :datetime
    add_column :customers, :confirmation_sent_at , :datetime
    add_column :customers, :unconfirmed_email, :string

    add_index  :customers, :confirmation_token, :unique => true
  end
  def self.down
    remove_index  :customers, :confirmation_token

    remove_column :customers, :unconfirmed_email
    remove_column :customers, :confirmation_sent_at
    remove_column :customers, :confirmed_at
    remove_column :customers, :confirmation_token
  end
end