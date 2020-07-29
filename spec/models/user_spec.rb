require "rails_helper"
require "spec_helper"

RSpec.describe User, type: :model do

  let(:user) {
    FactoryBot.create(:user)
  }

  let(:duplicate_user) { User.new }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(user).to be_valid
    end
    it "is not valid without username" do
      user.username = nil
      expect(user).not_to be_valid
    end
    it "is not valid without password" do
      user.password = nil
      expect(user).not_to be_valid
    end

    it "is not valid without email" do
      user.email = nil
      expect(user).not_to be_valid
    end

    it "is valid without phone number" do
      user.phone_number = nil
      expect(user).to be_valid
    end

    it "is valid without department" do
      user.department = nil
      expect(user).to be_valid
    end

    it "role is changeable" do
      user.role = 1
      expect(user).to be_valid
    end

    it "should reject user with username that is shorter than 6" do
      name_length = "a" * 5
      user.username = name_length
      expect(user).not_to be_valid
    end

    it "should reject user with username that is longer than 30" do
      name_length = "a" * 31
      user.username = name_length
      expect(user).not_to be_valid
    end

    it "is not allow duplicated username" do
      duplicate_user.username = user.username
      expect(duplicate_user).not_to be_valid
    end

    it "is not allow duplicated email" do
      duplicate_user.email = user.email
      expect(duplicate_user).not_to be_valid
    end

  end
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).not_to be_valid
      end
    end
  end

  describe "When email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        user.email = valid_address
        expect(user).to be_valid
      end
    end
  end

  describe "method search by name" do
    it "should return an array of results that match" do
      user_1 = FactoryBot.create(:user, username: "buithikieu")
      user_2 = FactoryBot.create(:user, username: "nguyenthekieu")
      users = User.find_by_user_name("k")
      expect(users).to include(user_1, user_2)
    end

    it "should not return value that doesn't match" do
      user_3 = FactoryBot.create(:user, username: "doanhuuhoa")
      expect(User.find_by_user_name("k")).not_to eq [user_3]
    end
  end

  describe "Associations" do
    it { is_expected.to have_many(:courses) }
    it { is_expected.to have_many(:course_users) }
    it { is_expected.to have_many(:tasks) }
    it { is_expected.to have_many(:user_tasks) }
    it { is_expected.to have_many(:subjects) }
    it { is_expected.to have_many(:user_subjects) }
  end
end