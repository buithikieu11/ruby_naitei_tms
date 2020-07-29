require 'rails_helper'
require 'support/factory_bot'
require 'support/database_cleaner'
RSpec.describe Course, type: :model do
it "has a valid factory" do
  FactoryBot.build(:course).should be_valid
end

describe "enum" do
  it { is_expected.to define_enum_for(:status).with_values(
    pending: 0,
    started: 1,
    finished: 2
  ) }
end

describe "validations" do
  valid_name="Python"
  invalid_name="course_ruby@123"
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(50) }
  it { is_expected.to_not allow_value(invalid_name).for(:name) }
  it { is_expected.to  allow_value(valid_name).for(:name) }
  it "should have a unique name" do
    FactoryBot.create(:course,:name=>"Foo")
    course1= Course.new(name:"Foo")
    course1.should_not be_valid
    course1.errors[:name].should include("has already been taken")
  end
  it { is_expected.to validate_presence_of(:description)}
  it { is_expected.to validate_presence_of(:status)}
  it { is_expected.to define_enum_for(:status).with([:pending, :started, :finished]) }
  it { is_expected.to validate_presence_of(:day_start)}
  it { is_expected.to validate_presence_of(:day_end)}
  it 'raises an error if end time is lower than start time' do
    expect {FactoryBot.create(:course,day_start:DateTime.now+2.weeks,day_end:DateTime.now).to raise_error(ActiveRecord::Errors)}
  end
end

describe "associations" do
  it { is_expected.to have_many(:users) }
  it { is_expected.to have_many(:course_users) }
  it { is_expected.to have_many(:course_subjects) }
  it { is_expected.to have_many(:subjects) }
end
describe "scopes" do
  
  let(:course_one) {FactoryBot.create(:course,name:"Ruby",created_at: 2.weeks.ago,status:1)}
  let(:course_two) {FactoryBot.create(:course,name:"Rails",created_at: 1.weeks.ago,status:0)}
  
  it ".sort_by_created_at to sort the courses in descending order created_at" do
   Course.sort_by_created_at.should eq [course_two,course_one]
  end

  it ".search_by_name to get course contain name" do
    Course.search_by_name("Ruby").should eq [course_one]
  end
  
  it ".get course by status" do
    Course.by_status("started").should eq [course_one]
  end

  it ".get course by ids" do
    ids=[]
    ids<<course_one.id
    ids<<course_two.id
    Course.by_ids(ids).should contain_exactly(course_one,course_two)
  end
end

end