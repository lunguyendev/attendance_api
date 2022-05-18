class Api::V1::Lecturer::QrCodeController < LecturerController
  include Api::Subject::QrCode
  def attendance
    raise Errors::ExceptionHandler::InvalidAction if @current_user.student?

    attendance_by_qr_code(target_student, target_qr, true)

    head :created
  end

  private
    def target_qr
      QrCode.find_by!(qr_code_string: params[:qr_code_string])
    end

    def target_student
      Student.find_by!(uid: params[:student_uid])
    end
end
