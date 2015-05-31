class AddGroupToContact < ActiveRecord::Migration
  def change
    add_reference :contacts, :group, index: true
    add_foreign_key :contacts, :groups
  end
end
