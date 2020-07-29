require "faker"

FactoryBot.define do
  factory :task do |f|
    f.name {Faker::Book.unique.title}
    f.subject_id {1}
    f.description {Faker::Lorem.unique.sentence}
    f.step {rand(1..10)}
    f.duration {rand(1..100)}
  end
end