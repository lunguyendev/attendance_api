class CreateQrCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :qr_codes, id: false do |t|
      t.string :uid, null: false, primary_key: true
      t.string :subject_uid
      t.string :qr_code_string
      t.date :date
      t.datetime :expired_at

      t.timestamps
    end
  end
end
