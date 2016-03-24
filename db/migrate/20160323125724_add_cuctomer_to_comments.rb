class AddCuctomerToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :customer, index: true, foreign_key: true
  end
end
