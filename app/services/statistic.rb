module Statistic
  def statistic_detail
    return {
      total_students: Student.count,
      total_lecturers: Lecturer.count,
      total_subjects: Subject.count,
      total_create_qr: QrCode.count,
      total_subjects_pending: Subject.pending.count,
      total_subjects_open: Subject.openning.count,
      total_subjects_close: Subject.close.count,
      total_attendance: Attendance.count
    }
  end
end
