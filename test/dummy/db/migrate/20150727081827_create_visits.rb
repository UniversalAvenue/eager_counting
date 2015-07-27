class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.references :place, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
