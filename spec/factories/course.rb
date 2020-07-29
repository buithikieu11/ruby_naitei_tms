require 'faker'
n= rand 1..100
FactoryBot.define do
  factory :course do
      name {"Courseonline#{n}"}
      description {Faker::Lorem.paragraph}
      status {Course.statuses.values.sample}
      day_start {DateTime.now}
      day_end {DateTime.now+n.weeks} 
      creator_id {1}
  end
  trait :invalid_course do
    name {nil}
    description {nil}
    day_start {nil}
    day_end {nil}
    creator_id {nil}
  end
end
