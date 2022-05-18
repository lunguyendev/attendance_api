class Api::V1::SubjectSerializer < ActiveModel::Serializer
  attributes \
    :uid,
    :name,
    :size,
    :description,
    :img,
    :location,
    :status,
    :number_join,
    :start_at,
    :end_at

  attributes :attendances
  def initialize(object, options = {})
    @current_user = options[:current_user]
    super
  end

  def attendances
    total_attendance = object.qr_codes.count
    if @current_user&.student?
      user_attendance = @current_user.attendances.where(subject_uid: object.uid).count
      return {
        total_attendance: total_attendance,
        user_attendance: user_attendance,
        attendance_detail: @current_user.attendances.where(subject_uid: object.uid)
      }
    end
    return {total_attendance: total_attendance}
  end

end
