class RemovePriorityFromAttachments < ActiveRecord::Migration
  def change
    remove_column :attachments, :priority, :integer
    add_column :attachments, :position, :integer
  end
end
