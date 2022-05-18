module Api::Subject::QrCode
  def generate_qr_code(subject, expired_time)
    raise Errors::ExceptionHandler::InvalidAction unless subject.close?

    qr_code = QrCode.create!(subject_uid: subject.uid, expired_at: Time.now + expired_time.to_i.minutes)
    return qr_code.qr_code_string
  end

  def qr_code_today(subject)
    qr_code = subject.qr_codes.created_at_desc.find_by(date: Date.today.strftime("%d-%m-%Y"))
    if qr_code
      return { has_qr_code: true, qr_code_string: qr_code.qr_code_string }
    end

    return { has_qr_code: false, qr_code_string: qr_code.qr_code_string }
  end

  def attendance_by_qr_code(student, qr_code, ignore_expired_at=false)
    take_part_in_subject = student.take_part_in_subjects.where(subject_uid: qr_code.subject_uid).first()
    raise Errors::ExceptionHandler::InvalidAction unless take_part_in_subject

    if Time.now > qr_code.expired_at and !ignore_expired_at
      raise Errors::ExceptionHandler::InvalidAction.new "QR Code has expired"
    end

    attendance = Attendance.new
    attendance.student_uid = student.uid
    attendance.qr_code_uid = qr_code.uid
    attendance.date = qr_code.date
    attendance.subject_uid = qr_code.subject_uid
    attendance.save!
  end
end
