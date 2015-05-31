class CreateMessageCategories < ActiveRecord::Migration
  def change
    create_table :message_categories do |t|
      t.references :message, index: true
      t.references :category, index: true

      t.timestamps null: false
    end
    add_foreign_key :message_categories, :messages
    add_foreign_key :message_categories, :categories
  end
end
