require 'rails_helper'
require 'spec_helper'
include Helpers

RSpec.describe Admin::TasksController, type: :controller do
  before(:all) do
    @subject = FactoryBot.create(:subject)
    @valid_params = FactoryBot.build(:task)
                        .as_json({except: [:id, :created_at, :updated_at]})
    @invalid_params = FactoryBot.build(:task, step: 0.1)
                          .as_json({except: [:duration, :id, :created_at, :updated_at]})
  end

  describe "GET #index" do
    it "redirects to root if not logged in" do
      get :index, params: { subject_id: @subject.id }
      expect(response).to redirect_to root_url
    end

    it "redirects to root if user do not have permission to access" do
      login_as_trainee
      get :index, params: { subject_id: @subject.id }
      expect(response).to redirect_to root_url
    end

    it "assigns @tasks" do
      login_as_supervisor
      task = FactoryBot.create(:task)
      get :index, params: { subject_id: @subject.id }
      expect(assigns(:tasks)).to eq [task]
    end

    it "should work with pagination" do
      login_as_supervisor
      task = FactoryBot.create(:task)
      (1..10).each { |i| FactoryBot.create(:task) }
      get :index, params: { subject_id: @subject.id, page: 1, per_page: 1 }
      expect(assigns(:tasks)).to eq [task]
    end

    it "renders the index template" do
      login_as_supervisor
      get :index, params: { subject_id: @subject.id }
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "redirects to root if not logged in" do
      get :new, params: { subject_id: @subject.id }
      expect(response).to redirect_to root_url
    end

    it "redirects to root if user do not have permission to access" do
      login_as_trainee
      get :new, params: { subject_id: @subject.id }
      expect(response).to redirect_to root_url
    end

    it "assigns new @task" do
      login_as_supervisor
      get :new, params: { subject_id: @subject.id }
      expect(assigns(:task)).to be_a_new(Task)
    end

    it "renders the new template" do
      login_as_supervisor
      get :new, params: { subject_id: @subject.id }
      expect(response).to render_template(:new)
    end
  end

  describe "GET #edit" do
    before(:each) do
      @task = FactoryBot.create(:task)
    end

    it "redirects to root if not logged in" do
      get :edit, params: { subject_id: @subject.id, id: @task.id }
      expect(response).to redirect_to root_url
    end

    it "redirects to root if user do not have permission to access" do
      login_as_trainee
      get :edit, params: { subject_id: @subject.id, id: @task.id }
      expect(response).to redirect_to root_url
    end

    it "redirects to index if the task is not found" do
      login_as_supervisor
      @task.destroy
      get :edit, params: { subject_id: @subject.id, id: @task.id }
      expect(response).to redirect_to admin_subject_tasks_path(subject_id: @subject.id)
    end

    it "assigns @task" do
      login_as_supervisor
      get :edit, params: { subject_id: @subject.id, id: @task.id }
      expect(assigns(:task)).to eq @task
    end

    it "renders the edit template" do
      login_as_supervisor
      get :edit, params: { subject_id: @subject.id, id: @task.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    it "redirects to root if not logged in" do
      post :create, params: { subject_id: @subject.id }
      expect(response).to redirect_to root_url
    end

    it "redirects to root if user do not have permission to access" do
      login_as_trainee
      post :create, params: { subject_id: @subject.id }
      expect(response).to redirect_to root_url
    end

    it "can create new @task with valid params" do
      login_as_supervisor
      expect {
        post :create, params: { subject_id: @subject.id, task: @valid_params }
      }.to change(Task, :count).by(1)
    end

    it "can not create new @task with invalid/missing params" do
      login_as_supervisor
      expect {
        post :create, params: { subject_id: @subject.id, task: @invalid_params }
      }.to change(Task, :count).by(0)
    end

    it "render the new template after trying to create new @task with invalid params" do
      login_as_supervisor
      post :create, params: { subject_id: @subject.id, task: @invalid_params }
      expect(response).to render_template(:new)
    end
  end

  describe "PATCH #update" do
    before(:each) do
      @task = FactoryBot.create(:task)
    end

    it "redirects to root if not logged in" do
      patch :update, params: { subject_id: @subject.id, id: @task.id, task: @valid_params }
      expect(response).to redirect_to root_url
    end

    it "redirects to root if user do not have permission to access" do
      login_as_trainee
      patch :update, params: { subject_id: @subject.id, id: @task.id, task: @valid_params }
      expect(response).to redirect_to root_url
    end

    it "redirects to index if the task is not found" do
      login_as_supervisor
      @task.destroy
      patch :update, params: { subject_id: @subject.id, id: @task.id, task: @valid_params }
      expect(response).to redirect_to admin_subject_tasks_path(subject_id: @subject.id)
    end

    it "can update @task with valid params" do
      login_as_supervisor
      patch :update, params: { subject_id: @subject.id, id: @task.id, task: @valid_params }
      expect(Task.find(@task.id).as_json).not_to eq @task.as_json
    end

    it "can not update @task with invalid/missing params" do
      login_as_supervisor
      patch :update, params: { subject_id: @subject.id, id: @task.id, task: @invalid_params }
      expect(Task.find(@task.id).as_json).to eq @task.as_json
    end

    it "render the edit template after trying to update @task with invalid params" do
      login_as_supervisor
      patch :update, params: { subject_id: @subject.id, id: @task.id, task: @invalid_params }
      expect(response).to render_template(:edit)
    end
  end

  describe "DELETE #delete" do
    before(:each) do
      @task = FactoryBot.create(:task)
    end

    it "redirects to root if not logged in" do
      delete :destroy, params: { subject_id: @subject.id, id: @task.id }
      expect(response).to redirect_to root_url
    end

    it "redirects to root if user do not have permission to access" do
      login_as_trainee
      delete :destroy, params: { subject_id: @subject.id, id: @task.id }
      expect(response).to redirect_to root_url
    end

    it "redirects to index if the task is not found" do
      login_as_supervisor
      @task.destroy
      delete :destroy, params: { subject_id: @subject.id, id: @task.id }
      expect(response).to redirect_to admin_subject_tasks_path(subject_id: @subject.id)
    end

    it "can delete @task" do
      login_as_supervisor
      expect {
        delete :destroy, params: { subject_id: @subject.id, id: @task.id }
      }.to change(Task, :count).by(-1)
    end
  end
end
