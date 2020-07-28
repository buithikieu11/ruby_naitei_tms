require 'rails_helper'

RSpec.describe Task, type: :model do
  it "has a valid factory" do
    FactoryBot.create(:subject)
    expect(FactoryBot.build(:task)).to be_valid
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :step }
    it { is_expected.to validate_numericality_of(:step).only_integer }
    it { is_expected.to validate_numericality_of(:step).is_greater_than(Settings.model.task.step.greater_than)}
    it { is_expected.to validate_presence_of :duration }
    it { is_expected.to validate_numericality_of(:duration).is_greater_than(Settings.model.task.duration.greater_than)}
  end

  describe "associations" do
    it { is_expected.to belong_to(:subject) }
    it { is_expected.to have_many(:user_tasks) }
  end

  describe "scopes" do
    before(:example) do
      FactoryBot.create(:subject)
      @task1 = FactoryBot.create(:task, name: "Git Basic", subject_id: Subject.last.id)
      @task2 = FactoryBot.create(:task, name: "Git Basic", subject_id: Subject.last.id)
      FactoryBot.create(:task, name: "SQL", subject_id: Subject.last.id)
    end

    it ".find_by_name should find the expected results" do
      expect(Task.find_by_name("Git")).to eq [@task1, @task2]
    end
  end
end
