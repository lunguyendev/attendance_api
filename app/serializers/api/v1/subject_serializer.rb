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
    :end_at,
    :is_join,
    :lecture

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

  def is_join
    return false unless @current_user&.student?

    @current_user.take_part_in_subjects.find_by(subject_uid: object.uid)&.present?
  end

  def lecture
    lecture = Lecturer.find_by(uid: object.lecture_uid)
    return {} unless lecture
    ActiveModelSerializers::SerializableResource.new(
      lecture,
      serializer: Api::V1::UserSerializer
    )
  end
end
