class Subject < ApplicationRecord
  belongs_to :user, foreign_key: :user_uid, primary_key: :uid
  has_many :take_part_in_subjects, foreign_key: :subject_uid, primary_key: :uid
  has_many :qr_codes, foreign_key: :subject_uid, primary_key: :uid
  has_many :attendances, foreign_key: :subject_uid, primary_key: :uid
  enum status: %i(pending openning close)

  scope :created_at_desc, -> { order created_at: :desc }
  scope :subject_uids, -> (uids) { where("uid IN (?)", uids) }
end
