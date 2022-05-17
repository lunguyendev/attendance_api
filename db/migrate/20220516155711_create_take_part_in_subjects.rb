class CreateTakePartInSubjects < ActiveRecord::Migration[6.0]
  def change
    create_table :take_part_in_subjects, id: false do |t|
      t.string :uid, null: false, primary_key: true
      t.string :subject_uid
      t.string :user_uid

      t.timestamps
    end
  end
end
