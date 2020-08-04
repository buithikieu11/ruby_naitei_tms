require "rails_helper"
require "spec_helper"
include SessionsHelper
include Admin::CoursesHelper

RSpec.describe "admin/courses/index.html.erb" do
    let!(:supervisor){FactoryBot.create(:user,role:User.roles[:supervisor])}
    let!(:course1){FactoryBot.create(:course,name:"course1",creator_id:supervisor.id,created_at:DateTime.now,status:Course.statuses[:pending])}
    let!(:course2){FactoryBot.create(:course,name:"course2",creator_id:supervisor.id,created_at:DateTime.now+2.weeks,status:Course.statuses[:started])}
    let!(:courses){[course1, course2]}

    before :each do
    log_in supervisor
    assign(:courses, courses)
    allow(view).to receive_messages(will_paginate: nil)
    view.lookup_context.view_paths.push "app/views/admin"
   end

  it "renders the _course partial for each course" do
    render
    view.should render_template(partial: "_course")
  end

  it "display all courses" do
    render
    view.should render_template(partial: "_course", count: 2)
  end

  it "display correct content of a course" do
    render
    2.times do |i|
    expect(rendered).to match /course#{i+1}/
    end
  end

  it "display correct title of index page" do
    render
    expect(rendered).to match I18n.t("view.admin.course.index.page_title")
  end

  it "has new course button" do
    render
    expect(rendered).to have_selector("a[href=\"#{new_admin_course_path}\"][class=\"btn btn-primary font-weight-bolder\"]")
  end
  
  it "has delete button for each course" do
    render 
    2.times do |i|
    expect(rendered).to have_selector("a[href=\"#{admin_course_path(courses[i].id)}\"][class=\"destroy-course\"][data-confirm=\"Are you sure?\"][data-remote=\"true\"][rel=\"nofollow\"][data-method=\"delete\"]")
    end
  end

  it "has a request.fullpath that is defined" do
    expect(controller.request.fullpath).to eq admin_courses_path
  end
end
