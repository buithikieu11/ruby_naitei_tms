class Admin::SubjectsController < Admin::ApplicationController
  include Admin::ApplicationHelper

  before_action :get_subject, except: [:index, :new, :create]
  before_action :extract_params, only: [:index]
  before_action :subject_params, only: [:create, :update]

  def index
    @subjects = Subject.find_by_name(@search)
                       .paginate(page: @page, per_page: @per_page)
    flash.now[:danger] = t("controller.admin.subject.index.no_result") if !@search.empty? && @subjects.count == 0
  end

  def new
    @subject = Subject.new
  end

  def show; end

  def edit; end

  def create
    params = subject_params.to_h
    params[:status] = params[:status].to_i
    params[:tasks_attributes].keys.each_with_index do |key,  index|
      params[:tasks_attributes][key][:step] = index + 1
    end
    @subject = Subject.new(params)
    if @subject.save
      flash[:success] = t("controller.admin.subject.create.created_successfully")
      redirect_to admin_subjects_path
    else
      render "new"
    end
  end

  def update
    params = subject_params
    params[:status] = params[:status].to_i
    if @subject.update(params)
      flash[:success] = t("controller.admin.subject.create.created_successfully")
      redirect_to admin_subjects_path
    else
      render "edit"
    end
  end

  def destroy
    @subject.destroy
    if @subject.destroyed?
      redirect_to admin_subjects_path,
                  flash: {success: t("controller.admin.subject.destroy.deleted")}
    else
      redirect_to admin_subjects_path,
                  flash: {danger: t("controller.admin.subject.destroy.failed")}
    end
  end

  private
  def get_subject
    @subject = Subject.find_by(id: params[:id])
    return if @subject
    flash[:danger] = t("controller.admin.subject.general.not_found")
    redirect_to admin_subjects_path
  end

  def extract_params
    @page = params[:page].present? && is_numeric?(params[:page]) ? params[:page] : Settings.controller.admin.subject.default_page
    @per_page = params[:per_page].present? && is_numeric?(params[:per_page]) ? params[:per_page] : Settings.controller.admin.subject.default_per_page
    @search = params[:search].present? && !params[:search].empty? ? params[:search] : ""
  end

  def subject_params
    params.require(:subject)
          .permit(:name, :description, :status, tasks_attributes: [:name, :duration, :description])
  end
end
