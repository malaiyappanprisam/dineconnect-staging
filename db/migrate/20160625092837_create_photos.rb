class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :photoable, polymorphic: true
      t.string :file_id

      t.timestamps null: false
    end
  end
end
