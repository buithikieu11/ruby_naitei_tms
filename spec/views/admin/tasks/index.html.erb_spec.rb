require "rails_helper"
require "spec_helper"
include Helpers

RSpec.describe "admin/tasks/index", type: :view do
  let!(:subject) { FactoryBot.create(:subject) }
  let!(:iterations) {10}

  before do
    controller.request.path_parameters[:subject_id] = subject.id
    assign(:subject, subject)
    allow(view).to receive_messages(will_paginate: nil)
    @tasks = []
    iterations.times do |i|
      @tasks << FactoryBot.create(:task, name: "task#{i}", subject_id: subject.id)
    end
    assign(:tasks, @tasks)
  end

  it "displays all the tasks" do
    render
    iterations.times do |i|
      expect(rendered).to match /task#{i}/
    end
  end

  it "displays the title" do
    render
    expect(rendered).to match I18n.t("view.admin.task.index.page_title", subject_name: subject.name)
  end

  it "has edit button for each task" do
    render
    iterations.times do |i|
      expect(rendered).to have_selector("a[href=\"#{edit_admin_subject_task_path(subject, @tasks[i])}\"][class=\"btn btn-sm btn-clean btn-icon\"]")
    end
  end

  it "has delete button for each task" do
    render
    iterations.times do |i|
      expect(rendered).to have_selector("a[href=\"#{edit_admin_subject_task_path(subject, @tasks[i])}\"][class=\"btn btn-sm btn-clean btn-icon\"]")
    end
  end

  it "has a request.fullpath that is defined" do
    controller.extra_params = { :subject_id => subject.id }
    expect(controller.request.fullpath).to eq admin_subject_tasks_path(subject)
  end
end