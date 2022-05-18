class Attendance < ApplicationRecord
  belongs_to :subject, foreign_key: :subject_uid, primary_key: :uid
  belongs_to :qr_code, foreign_key: :qr_code_uid, primary_key: :uid
  belongs_to :student, foreign_key: :student_uid, primary_key: :uid

  validates :student_uid, uniqueness: { scope: :qr_code_uid }
end
