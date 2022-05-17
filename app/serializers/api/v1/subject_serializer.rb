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
end
