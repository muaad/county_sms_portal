class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :text
      t.references :contact, index: true
      t.boolean :incoming, default: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :messages, :contacts
    add_foreign_key :messages, :users
  end
end
