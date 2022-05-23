# frozen_string_literal: true
class Api::V1::Admin::SubjectController < AdminController
  include Api::Subject::FilterSubject

  def create
    subject = @current_user.subjects.create(params_subject_create)

    render json: subject, serializer: Api::V1::SubjectSerializer, current_user: @current_user, status: :created
  end

  def update
    if target_subject.pending?
      target_event.update!(params_subject_create)
      return head :accepted
    end

    raise Errors::ExceptionHandler::PermissionDenied, I18n.t("errors.permission_denied")
  end

  def destroy
    if target_subject.pending?
      target_event.destroy!
      return head :accepted
    end

    raise Errors::ExceptionHandler::PermissionDenied, I18n.t("errors.permission_denied")
  end

  def index
    subjects = filter_subject(@current_user, params[:type])


    @collection_subjects = Kaminari.paginate_array(subjects).page(params[:page]).per(10)

    subject_serializable = ActiveModelSerializers::SerializableResource.new(
      @collection_subjects,
      each_serializer: Api::V1::SubjectSerializer,
      current_user: @current_user
    )

    response_hash = {
      data: subject_serializable,
      total_page: @collection_subjects.total_pages,
      current_page: @collection_subjects.current_page,
      total_count: subjects.count
    }

    render json: response_hash
  end

  def open_subject
    raise Errors::ExceptionHandler::InvalidAction if target_subject.openning?
    target_subject.openning!
    target_subject.approve_by = @current_user.uid
    target_subject.save!

    head :accepted
  end

  def close_subject
    raise Errors::ExceptionHandler::InvalidAction if target_subject.close?
    target_subject.close!
    target_subject.approve_by = @current_user.uid
    target_subject.save!

    head :accepted
  end

  def pending_subject
    raise Errors::ExceptionHandler::InvalidAction if target_subject.pending?
    target_subject.pending!
    target_subject.approve_by = @current_user.uid
    target_subject.save!

    head :accepted
  end

  private
    def params_subject_create
      params.permit(
        :name,
        :lecture_uid,
        :size,
        :description,
        :location,
        :img,
        :start_at,
        :end_at
      )
    end

    def target_subject
      @target_subject = Subject.find(params[:subject_uid])
    end
end
