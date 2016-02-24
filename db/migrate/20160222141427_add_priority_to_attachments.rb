class AddPriorityToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :priority, :integer
  end
end
