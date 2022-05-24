# frozen_string_literal: true
class Api::V1::SubjectController < ApplicationController
  include Api::Subject::QrCode
  include Api::Subject::FilterSubject
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

  def my_subject
    subjects = my_subject_filter(@current_user, params[:type])

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

  def search
    subjects = Subject.where("name LIKE '%#{params[:name]}%'").created_at_desc

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

  def show
    render json: target_subject, serializer: Api::V1::SubjectSerializer, current_user: @current_user
  end

  def create_qr_code
    raise Errors::ExceptionHandler::InvalidAction if @current_user.student?
    qr_code = generate_qr_code(target_subject, params[:expired_time])

    render json: { qr_code: qr_code}, status: :created
  end

  def get_qr_today
    raise Errors::ExceptionHandler::InvalidAction if @current_user.student?
    value = qr_code_today(target_subject)

    render json: value, status: :ok
  end

  def attendance_detail
    render json: target_subject, serializer: Api::V1::AttendanceSerializer
  end

  def list_student
    user_uids = target_subject.take_part_in_subjects.pluck(:user_uid)
    users = User.users_by_ids(user_uids)

    render json: users, each_serializer: Api::V1::Admin::UserSerializer
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
