class Api::V1::Student::AttendanceSerializer < ActiveModel::Serializer
  attributes \
    :created_at,
    :date

  belongs_to :subject, serializer: Api::V1::SubjectSerializer
end
