class CreatePeople < ActiveRecord::Migration[7.1]
  def change
    create_table :people do |t|
      t.string :name
      t.string :dni
      t.string :company

      t.timestamps
    end
  end
end
