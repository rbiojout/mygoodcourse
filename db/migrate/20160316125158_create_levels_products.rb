class CreateLevelsProducts < ActiveRecord::Migration
  def change
    create_table :levels_products , id: false do |t|
      t.belongs_to :level, index: true
      t.belongs_to :product, index: true
    end
  end
end
