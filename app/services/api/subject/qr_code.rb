module Api::Subject::QrCode
  def generate_qr_code(subject, expired_time)
    qr_code = QrCode.create!(subject_uid: subject.uid, expired_at: Time.now + expired_time.to_i.minutes)
    return qr_code.qr_code_string
  end

  def qr_code_today(subject)
    qr_code = subject.qr_codes.find_by(date: Date.today.strftime("%d-%m-%Y"))
    if qr_code
      return { has_qr_code: true, qr_code_string: qr_code.qr_code_string }
    end

    return { has_qr_code: false, qr_code_string: qr_code.qr_code_string }
  end
end
