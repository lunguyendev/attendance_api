class CreateAttendances < ActiveRecord::Migration[6.0]
  def change
    create_table :attendances, id: false do |t|
      t.string :uid, null: false, primary_key: true
      t.string :subject_uid
      t.string :qr_code_uid
      t.string :student_uid
      t.date :date

      t.timestamps
    end
  end
end
