class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.string :email, null: false
      t.string :phone, null: false
      t.string :mobile, null: false
      t.references :person, index: true, foreign_key: true

      t.timestamps
    end

    add_index :contacts, :email, unique: true
  end
end
