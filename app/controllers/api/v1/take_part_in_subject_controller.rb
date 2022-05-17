# frozen_string_literal: true

class Api::V1::TakePartInSubjectController < ApplicationController
  include Api::Subject::JoinSubject
  before_action :target_subject
  def register
    join_subject(@current_user, @target_subject)

    head :accepted
  end

  def cancel
    cancel_subject(@current_user, @target_subject)

    head :accepted
  end

  private
    def target_subject
      @target_subject = Subject.find(params[:subject_uid])
    end
end
