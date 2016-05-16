class AddBirthdateToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :birthdate, :date
    add_column :customers, :score_comments, :decimal
    add_column :customers, :nb_comments, :integer
  end
end
