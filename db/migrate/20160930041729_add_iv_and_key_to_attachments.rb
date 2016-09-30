class AddIvAndKeyToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :iv, :binary
    add_column :attachments, :key, :binary
  end
end
