class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string :filename
      t.string :key
      t.string :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
