require 'rails_helper'
require 'support/factory_bot'
require 'support/database_cleaner'
include SessionsHelper
RSpec.describe Admin::CoursesController, type: :controller do

  # declare user 
  let!(:owner){ FactoryBot.create(:user, role: User.roles[:supervisor]) }
  let!(:supervisor){ FactoryBot.create(:user, role: User.roles[:supervisor]) }
  let!(:trainee){ FactoryBot.create(:user,role: User.roles[:trainee]) }

  # declare course,subject,course_user
  let!(:course){ FactoryBot.create(:course, creator_id: owner.id) }
  let!(:subject_one){ FactoryBot.create(:subject) }
  let!(:subject_two){ FactoryBot.create(:subject) }
  let!(:course_one){ FactoryBot.create(:course, name: "Python", creator_id: owner.id, created_at: DateTime.now, status: Course.statuses[:pending]) }
  let!(:course_two){ FactoryBot.create(:course, name: "Ruby", creator_id: owner.id, created_at: DateTime.now+2.weeks, status: Course.statuses[:started]) }
  let!(:course_user1){ course_one.course_users.create(user_id: owner.id, role: CourseUser.roles[:supervisor]) }
  let!(:course_user2){ course_two.course_users.create(user_id: owner.id, role: CourseUser.roles[:supervisor]) }
  # index method
  describe "GET #index" do

    context "access denied" do
      it "redirects to root if not logged in" do
        get :index
        expect(response).to redirect_to root_url
      end
  
      it "redirects to root if user do not have permission to access" do
        log_in trainee
        get :index
        expect(response).to redirect_to root_url
      end
    end

    it "should render a list of courses" do
      log_in owner
      get :index
      expect(assigns(:courses)).to eq [course_two, course_one]
    end 

    it "should render a list courses by course's name" do
      log_in owner
      get :index,params: { search: "Python" }
      expect(assigns(:courses)).to eq [course_one]
    end

    it "should render a list courses by course's status" do
      log_in owner
      get :index,params: { state: Course.statuses[:"pending"] }
      expect(assigns(:courses)).to eq [course_one]
    end

    it "renders the index template" do
      log_in owner
      get :index
      expect(response).to render_template(:index)
    end
  end

  # new method :
  describe "GET #new" do

    context "access denied" do
      it "redirects to root if not logged in" do
        get :new
        expect(response).to redirect_to root_url
      end
  
      it "redirects to root if user do not have permission to access" do
        log_in trainee
        get :new
        expect(response).to redirect_to root_url
      end
    end
  
    it "assigns a new course to @course" do
      log_in owner
      get :new
      expect(assigns(:course)).to be_a_new(Course)
    end

    it "renders the #new view" do
      log_in owner
      get :new
      expect(response).to render_template :new
    end

    it "returns a http status 200" do
      log_in owner
      get :new
      expect(response).to have_http_status(200)
    end

    it {should route(:get, "admin/courses/new").to(action: :new)}
  end

  # create method :
  describe "POST #create" do

    context "access denied" do
      it "redirects to root if not logged in" do
        post :create
        expect(response).to redirect_to root_url
      end
    
      it "redirects to root if user do not have permission to access" do
        log_in trainee
        post :create
        expect(response).to redirect_to root_url
      end
      end
    context "create a new course success" do
      let!(:valid_params){ FactoryBot.attributes_for(:course, name: "Java core").merge({subject_ids: [subject_one.id,subject_two.id]}) }

      it "creates a new course" do
        log_in owner
        expect{
          post :create,
          params: {course: valid_params}
        }.to change(Course,:count).by(1)
        end
  
      it "creates a new course_user" do
        log_in owner
        expect{
          post :create,
          params: {course: valid_params}
        }.to change(CourseUser,:count).by(1)
        end

      it "creates a new course_subject" do
        log_in owner
        expect{
          post :create,
          params: {course: valid_params}
        }.to change(CourseSubject,:count).by(2)
        end
   
      it "flash success message" do
        log_in owner
        post :create, params: {course: valid_params}
        expect(flash[:success]).to eq(I18n.t "controller.admin.course.create.create_success")
      end
  
      it "redirects to the #index" do
        log_in owner
        post :create, params: {course: valid_params}
        expect(response).to redirect_to(admin_courses_path)
      end
    end
  
    context "create a new course failed" do
      let!(:invalid_params){ FactoryBot.attributes_for(:course, :invalid_course).merge({subject_ids: []}) }
      
      it "does not save the new course" do
        log_in owner
        expect{
          post :create,
          params: {course: invalid_params}
        }.to_not change(Course,:count)
      end
  
      it "re-renders the new method" do
        log_in owner
        post :create, params: {course: invalid_params}
        expect(response).to render_template :new
      end
  
      it "flash failed message" do
        log_in owner
        post :create, params: {course: invalid_params}
        expect(flash[:warning]).to eq(I18n.t "controller.admin.course.create.create_fail")
      end
    end
  
    it {should route(:post, "admin/courses").to(action: :create)}
  end
  
  # deleted method :
  describe "DELETE #destroy" do
    let!(:course_valid){ FactoryBot.create(:course, name: "Rails tutorials", creator_id: owner.id) }#owner
    let!(:course_invalid){ FactoryBot.create(:course, name: "Java spring",creator_id: supervisor.id) } #supervisor
    
    context "access denied" do
      it "redirects to root if not logged in" do
        delete :destroy,params: { id: course_valid.id }
        expect(response).to redirect_to root_url
      end
  
      it "redirects to root if user do not have permission to access" do
        log_in trainee
        delete :destroy,params: { id: course_valid.id }
        expect(response).to redirect_to root_url
      end
    end

    it "should delete a course using ajax" do
      log_in owner
      lambda do
        delete :destroy, xhr: true, params: {
        id: course_valid.id,
      }
      end.should change(Course, :count).by(-1)   
    end

    it "should destroy a course" do
      log_in owner
      delete :destroy, xhr: true, params: {
        id: course_valid.id,
      }, format: "js"
      flash[:success].should == I18n.t("controller.admin.course.destroy.delete_success")
    end  
  
    it "should not delete a course if is not owner" do
      log_in owner
      delete :destroy, xhr: true, params: {
      id: course_invalid.id,
      }
      flash[:danger].should == I18n.t("controller.admin.course.destroy.delete_failed")
      expect(response).to redirect_to admin_courses_url
    end

    it "should not delete a course if it doesn't exit" do
      log_in owner
      delete :destroy, xhr: true, params: {
      id: 0,
      }
      flash[:danger].should == I18n.t("controller.admin.course.index.course_not_found")
      expect(response).to redirect_to admin_courses_url
    end

  end

end