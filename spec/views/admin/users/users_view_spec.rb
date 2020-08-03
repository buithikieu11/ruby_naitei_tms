require "spec_helper"
require "rails_helper"

RSpec.describe "admin/users/index", type: :view do
  let(:iterator) { 40 }

  before(:each) do
    allow(view).to receive_messages(will_paginate: nil)
    @users = []
    iterator.times do |i|
      @users << FactoryBot.create(:user, username: "username#{i}")
    end
    assign(:users, @users)
  end

  describe "admin/users/index.html.erb" do
    it "should display the list of users" do
      render
      iterator.times do |i|
        expect(rendered).to match(/username#{i}/)
      end
    end

    it "should have edit button for each user record" do
      render
      iterator.times do |i|
        expect(rendered).to have_selector("a[href=\"#{edit_admin_user_path(@users[i])}\"][class=\"btn btn-sm btn-clean btn-icon\"]")
      end
    end

    it "should have delete button for each user record" do
      render
      iterator.times do |i|
        expect(rendered).to have_selector("a[href=\"#{admin_user_path(@users[i])}\"][class=\"btn btn-sm btn-clean btn-icon\"]")
      end
    end
  end
end

