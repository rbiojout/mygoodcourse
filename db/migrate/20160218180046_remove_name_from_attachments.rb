class RemoveNameFromAttachments < ActiveRecord::Migration
  def change
    remove_column :attachments, :file_name, :string
    remove_column :attachments, :preview, :string
  end
end
