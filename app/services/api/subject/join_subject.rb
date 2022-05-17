# frozen_string_literal: true

module Api::Subject::JoinSubject
  def join_subject(user, subject)
    raise Errors::ExceptionHandler::InvalidAction unless subject.openning?
    raise Errors::ExceptionHandler::InvalidAction if subject.size == subject.number_join
    raise Errors::ExceptionHandler::InvalidAction if user.take_part_in_subjects.find_by(subject_uid: subject.uid)&.present?

    ApplicationRecord.transaction do
      user.take_part_in_subjects.create!({subject_uid: subject.uid})
      number_join = subject.number_join + 1
      subject.number_join = number_join

      subject.save!
    end
  end

  def cancel_subject(user, subject)
    raise Errors::ExceptionHandler::InvalidAction unless subject.openning?
    ApplicationRecord.transaction do
      take_part_in_subject = user.take_part_in_subjects.where(subject_uid: subject.uid).first()

      raise Errors::ExceptionHandler::InvalidAction unless take_part_in_subject

      number_join = subject.number_join - 1
      subject.number_join = number_join

      subject.save!
      take_part_in_subject.destroy!
    end
  end
end
