class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file
      t.string :file_name
      t.integer :file_size
      t.string :file_type
      t.integer :nbpages
      t.decimal :version_number
      t.boolean :active
      t.string :preview
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
