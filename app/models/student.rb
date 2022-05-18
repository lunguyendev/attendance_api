# frozen_string_literal: true

class Student < User
  has_many :attendances, foreign_key: :student_uid, primary_key: :uid
end
