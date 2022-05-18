class QrCode < ApplicationRecord
  include Util::Generation
  belongs_to :subject, foreign_key: :subject_uid, primary_key: :uid
  has_many :attendances, foreign_key: :qr_code_uid, primary_key: :uid

  before_validation(on: :create) do
    self.qr_code_string = generate_token
    self.date = Date.today.strftime("%d-%m-%Y")
  end

  scope :created_at_desc, -> { order created_at: :desc }
end
