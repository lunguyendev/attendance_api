class Api::V1::AttendanceSerializer < ActiveModel::Serializer
  attributes \
    :date,
    :students,
    :total

  def date
    return object.qr_codes.created_at_asc.map do |qr_code|
      {
        uid: qr_code.uid,
        date: qr_code.date
      }
    end
  end

  def students
    students_arr = []
    user_uids = object.take_part_in_subjects.pluck(:user_uid)
    students = User.users_by_ids(user_uids).name_asc
    students.each do |student|
      attendance = {
        "detail": student.attendances.where(subject_uid: object.uid).map do |a|
          {
            uid: a.qr_code_uid,
            date: a.date
          }
        end,
        "total": student.attendances.where(subject_uid: object.uid).count
      }
      students_arr << {
        name: student.name,
        id_student: student.id_student,
        attendances: attendance
      }
    end
    return students_arr
  end

  def total
    object.qr_codes.count
  end
end
