class AddDeletedAtToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :deleted_at, :datetime
    add_index :people, :deleted_at
  end
end
