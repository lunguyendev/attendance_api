class QrCode < ApplicationRecord
  include Util::Generation
  belongs_to :subject, foreign_key: :subject_uid, primary_key: :uid

  before_validation(on: :create) do
    self.qr_code_string = generate_token
    self.date = Date.today.strftime("%d-%m-%Y")
  end

  validates :date, uniqueness: { scope: :subject_uid }
end
