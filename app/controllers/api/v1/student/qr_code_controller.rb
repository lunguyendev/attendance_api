class Api::V1::Student::QrCodeController < StudentController
  include Api::Subject::QrCode
  def attendance
    attendance_by_qr_code(@current_user, target_qr)

    head :ok
  end

  def list_attendance
    attendances = @current_user.attendances.where(subject_uid: param_subject[:subject_uid])

    render json: attendances, each_serializer: Api::V1::Student::AttendanceSerializer
  end

  def attendance_manual
    raise Errors::ExceptionHandler::InvalidAction if @current_user.student?

    attendance_by_qr_code(@target_student, target_qr)

    head :created
  end

  private
    def target_qr
      QrCode.find_by!(qr_code_string: params[:qr_code_string])
    end

    def target_student
      Student.find_by!(uid: params[:student_uid])
    end

    def param_subject
      params.permit(
        :subject_uid
      )
    end
end
