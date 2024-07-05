class CreatePeople < ActiveRecord::Migration[7.1]
  def change
    create_table :people do |t|
      t.string :registration, null: false
      t.string :name, null: false
      t.date :date_birth, null: true
      t.string :state_birth, null: true
      t.string :city_birth, null: true
      t.integer :marital_status, null: true
      t.integer :gender, null: true

      t.references :workspace, index: true, foreign_key: true
      t.references :job_role, index: true, foreign_key: true

      t.timestamps
    end

    add_index :people, :gender
    add_index :people, [:gender, :job_role_id]
    add_index :people, [:gender, :workspace_id]
    add_index :people, :registration, unique: true
    add_index :people, [:workspace_id, :job_role_id], unique: true
  end
end
