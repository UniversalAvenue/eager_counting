class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.references :country, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
