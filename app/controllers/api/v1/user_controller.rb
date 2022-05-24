# frozen_string_literal: true

class Api::V1::UserController < ApplicationController
  include Util::Generation
  skip_before_action :authorize_request, only: [:login, :change_password, :create]

  def login
    authenticator = Auth::Authentication.new(auth_params[:email], auth_params[:password])

    unless authenticator.authenticable?
      head :unauthorized
      return
    end

    unless authenticator.authenticated_user.actived?
      return render json: { message: I18n.t("message_response.account_inactived") }, status: :unauthorized
    end

    render json: authenticator.authenticated_user, serializer: Api::V1::User::LoginSerializer
  end

  def logout
    head :ok
  end

  def ping_role
    render json: { role: @current_user.role }
  end

  def profile
    render json: @current_user, each_serializer: Api::V1::UserSerializer
  end

  def create
    email = params_user["email"]
    name = params_user["name"]
    hash_password = generate_hash_password(params_user["password"])
    phone_number = params_user["phone"]
    avatar = params_user["avatar"]

    student = Student.create!(
      email: email,
      hashed_password: hash_password,
      name: name,
      phone: phone_number,
      avatar: avatar,
      role: 0,
      status: 1
    )
    student.actived!
    authenticator = Auth::Authentication.new(student.email, params_user[:password])
    unless authenticator.authenticable?
      head :unauthorized
      return
    end
    render json: authenticator.authenticated_user, serializer: Api::V1::User::LoginSerializer
  end

  def update
    target_user.update!(param_updade)

    head :accepted
  end

  def change_password
    user = User.find(token_valid.qr_code_id)
    password_user = generate_hash_password(change_password_params[:password])
    ApplicationRecord.transaction do
      user.update_attributes!(hashed_password: password_user, status: "actived", role: "creator")
      token_valid.destroy!
    end
  end

  def search_email
    users = User.not_admin.where("email LIKE ?", "%#{params[:search]}%").order("email ASC")

    render json: users, each_serializer: Api::V1::Admin::UserSerializer
  end

  def list_lecturer
    users = Lecturer.all

    render json: users, each_serializer: Api::V1::Admin::UserSerializer
  end

  private
    def auth_params
      params.permit(:email, :password)
    end

    def token_valid
      return @token if @token = Token.find_by(qr_code_string: change_password_params[:token])

      raise Errors::ExceptionHandler::InvalidToken
    end

    def change_password_params
      params.require(:change_password)
            .permit(:token, :password)
    end

    def params_user
      params.permit(
        :email,
        :name,
        :phone,
        :avatar,
        :password
      )
    end

    def target_user
      @user ||= User.find(params[:uid])
    end

    def param_updade
      params.permit(
        :name,
        :phone,
        :avatar,
        :id_lecturer,
        :id_student
      )
    end
end
