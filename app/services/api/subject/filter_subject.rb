module Api::Subject::FilterSubject
  def filter_subject user, type
    case type
    when "pending"
      Subject.pending.created_at_desc
    when "openning"
      Subject.openning.created_at_desc
    when "close"
      Subject.close.created_at_desc
    else
      Subject.created_at_desc
    end
  end

  def my_subject_filter user, type
    if user.admin?
      return my_subject_admin user, type
    end
    if user.lecturer?
      return my_subject_lecture user, type
    end
    if user.student?
      return my_subject_student user, type
    end

    return []
  end

  def my_subject_admin user, type
    case type
    when "pending"
      user.subjects.pending.created_at_desc
    when "openning"
      user.subjects.openning.created_at_desc
    when "close"
      user.subjects.close.created_at_desc
    else
      user.subjects.created_at_desc
    end
  end

  def my_subject_lecture user, type
    case type
    when "pending"
      user.subject_lecturers.pending.created_at_desc
    when "openning"
      user.subject_lecturers.openning.created_at_desc
    when "close"
      user.subject_lecturers.close.created_at_desc
    else
      user.subject_lecturers.created_at_desc
    end
  end

  def my_subject_student user, type
      subject_uids = user.take_part_in_subjects.pluck(:subject_uid)
      subjects = Subject.subject_uids(subject_uids)
      case type
      when "pending"
        subjects.pending.created_at_desc
      when "openning"
        subjects.openning.created_at_desc
      when "close"
        subjects.close.created_at_desc
      else
        subjects.created_at_desc
      end
  end
end
