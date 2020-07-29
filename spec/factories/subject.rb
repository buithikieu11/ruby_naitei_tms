require "faker"

FactoryBot.define do
  factory :subject do |f|
    f.name {Faker::Book.unique.title}
    f.description {Faker::Lorem.unique.sentence}
  end
end