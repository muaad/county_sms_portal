class AddAccountToModels < ActiveRecord::Migration
  def change
  	add_reference :messages, :account, index: true
    add_foreign_key :messages, :accounts

  	add_reference :categories, :account, index: true
    add_foreign_key :categories, :accounts

  	add_reference :contacts, :account, index: true
    add_foreign_key :contacts, :accounts

  	add_reference :message_categories, :account, index: true
    add_foreign_key :message_categories, :accounts
  end
end
