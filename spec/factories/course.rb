require 'faker'
n= rand 1..100
FactoryBot.define do
  factory :course do
      name {"Courseonline#{n}"}
      description {Faker::Lorem.paragraph}
      status {Course.statuses.values.sample}
      day_start {DateTime.now}
      day_end {DateTime.now+n.weeks} 
  end
end
