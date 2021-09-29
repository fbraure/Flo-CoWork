class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.integer :progress, default: 0
      t.references :user, null: false, foreign_key: true
      t.boolean :active, default: false
      t.timestamps
    end
  end
end
