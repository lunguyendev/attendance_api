class CreateSubjects < ActiveRecord::Migration[6.0]
  def change
    create_table :subjects, id: false do |t|
      t.string :uid, null: false, primary_key: true
      t.string :user_uid
      t.string :name
      t.string :size
      t.string :lecture_uid
      t.string :description
      t.string :img
      t.string :location
      t.integer :status, default: 0
      t.integer :number_join, default: 0
      t.date :start_at
      t.date :end_at

      t.timestamps
    end
  end
end
