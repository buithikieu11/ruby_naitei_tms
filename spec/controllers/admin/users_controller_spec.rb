require "rails_helper"
require "spec_helper"
include Helpers

RSpec.describe Admin::UsersController, type: :controller do
  let(:user_1) { FactoryBot.create(:user) }
  let(:user_2) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, role: User.roles[:supervisor])}
  let(:invalid_user) {
    FactoryBot.build(:user,
      email: Faker::Internet.unique.username,
      password: "123456",
      password_confirmation: "",
    ).as_json
  }

  before(:each) do
    log_in(admin)
  end

  describe "GET users#index" do
    it "should render a list of users" do
      get :index
      expect(assigns(:users)).to eq([admin, user_1, user_2])
    end

    it "should render :index view" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "POST users#new" do
    it "should render :new view" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST users#create" do
    context "with valid attributes" do
      it "should create new user object" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end

      it "should create a new user" do
        @new_user = FactoryBot.create(:user)
        expect {
          post :create, params: {user: FactoryBot.attributes_for(:user)}
        }.to change(User, :count).by(1)
      end

      it "should redirect to the new user" do
        post :create, params: {user: FactoryBot.attributes_for(:user)}
        expect(response).to redirect_to admin_users_url
      end
    end

    context "with invalid attribute(s)" do
      it "should not create a new user" do
        expect {
          post :create, params: { user: invalid_user }
        }.to_not change(User, :count)
      end

      it "should re-render :new view" do
        post :create, params: { user: invalid_user }
        expect(response).to render_template :new
      end
    end
  end

  describe "PUT users#update/:id" do
    context "with valid attributes" do
      it "should return a located user" do
        put :update, params: {
            id: user_1.id,
            user: FactoryBot.attributes_for(:user)
        }
        expect(assigns(:user)).to eq(user_1)
      end

      it "should update user's attributes" do
        put :update, params: {
          id: user_1.id,
          user: FactoryBot.attributes_for(:user, username: "minhtam2048", email: "minhtam2048@gmail.com")
        }
        user_1.reload
        expect(user_1.username).to eq("minhtam2048")
        expect(user_1.email).to eq("minhtam2048@gmail.com")
      end

      it "should redirect to admin_users_path" do
        put :update, params: {
          id: user_1.id,
          user: FactoryBot.attributes_for(:user)
        }
        expect(response).to redirect_to admin_users_path
      end
    end

    context "with invalid attributes" do
      it "should return a located user" do
        put :update, params: {
            id: user_1.id,
            user: FactoryBot.attributes_for(:user)
        }
        expect(assigns(:user)).to eq(user_1)
      end

      it "should not change user's attributes" do
        put :update, params: {
            id: user_1,
            user: FactoryBot.attributes_for(:user, email: "BadStringThat'sNotEmail")
        }
        user_1.reload
        expect(user_1.username).to_not eq("BadStringThatIsNotEmail")
      end

      it "should not change user's password with wrong password confirmation" do
        put :update, params: {
            id: user_1,
            user: FactoryBot.attributes_for(:user, password: "1234567", password_confirmation: "123456")
        }
        expect(user_1.password).to_not eq("1234567")
      end

      it "should not change user's password with invalid password confirmation" do
        put :update, params: {
            id: user_1,
            user: FactoryBot.attributes_for(:user, password: "1234567", password_confirmation: nil)
        }
        expect(user_1.password).to_not eq("1234567")
      end

      it "should re-render admin edit user page" do
        put :update, params: {
            id: user_1,
            user: FactoryBot.attributes_for(:user, email: "BadStringThatIsNotEmail")
        }
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE users#destroy" do
    context "with valid user" do
      it "should delete the user" do
        expect {
          delete :destroy, params: {
              id: admin,
          }
        }.to change(User, :count).by(-1)
      end

      it "should re-render admin user page" do
        delete :destroy, params: {
            id: user_1
        }
        expect(response).to redirect_to admin_users_path
      end
    end

    context "with invalid user" do
      invalid_user_id = Faker::Internet.unique.username
      it "should re-render to admin user page" do
        delete :destroy, params: {
            id: invalid_user_id
        }
        expect(response).to redirect_to admin_users_path
      end
    end
  end
end