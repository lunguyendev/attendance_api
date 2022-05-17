class TakePartInSubject < ApplicationRecord
  belongs_to :user, foreign_key: :user_uid, primary_key: :uid
  belongs_to :subject, foreign_key: :subject_uid, primary_key: :uid
end
