class CreateStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :students do |t|
      t.string :name
      t.integer :admission_year
      t.boolean :active
      t.references :classroom, foreign_key: true
      t.timestamps
    end
  end
end
