class CreateClassrooms < ActiveRecord::Migration[5.1]
  def change
    create_table :classrooms do |t|
      t.string :name
      t.string :code
      t.boolean :active
      t.timestamps
    end
  end
end
