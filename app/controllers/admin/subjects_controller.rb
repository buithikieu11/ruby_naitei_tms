class Admin::SubjectsController < Admin::ApplicationController
  include Admin::ApplicationHelper

  before_action :get_subject, only: [:destroy]
  before_action :extract_params, only: [:index]

  def index
    @subjects = Subject.find_by_name(@search)
                       .paginate(page: @page, per_page: @per_page)
    flash.now[:danger] = t("controller.admin.controller.subject.index.no_result") if !@search.empty? && @subjects.count == 0
  end

  def destroy
    @subject.destroy
    if @subject.destroyed?
      redirect_to admin_subjects_path,
                  flash: {success: t("controller.admin.controller.subject.destroy.deleted")}
    else
      redirect_to admin_subjects_path,
                  flash: {danger: t("controller.admin.controller.subject.destroy.failed")}
    end
  end

  private
  def get_subject
    @subject = Subject.find_by(id: params[:id])
    return if @subject
    flash[:danger] = t("controller.admin.controller.subject.general.not_found")
    redirect_to admin_subjects_path
  end

  def extract_params
    @page = params[:page].present? && is_numeric?(params[:page]) ? params[:page] : Settings.controller.admin.subject.default_page
    @per_page = params[:per_page].present? && is_numeric?(params[:per_page]) ? params[:per_page] : Settings.controller.admin.subject.default_per_page
    @search = params[:search].present? && !params[:search].empty? ? params[:search] : ""
  end
end
