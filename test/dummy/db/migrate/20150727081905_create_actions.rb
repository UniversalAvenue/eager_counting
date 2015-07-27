class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.references :visit, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
