require "faker"

FactoryBot.define do
  factory :user do
    username                { Faker::Internet.unique.username(specifier: 7..9) }
    email                   { Faker::Internet.unique.email }
    password                { "123456" }
    password_confirmation   { "123456" }
    phone_number            { Faker::Number.number(digits: 12)}
    department              { Faker::Company.industry }
  end

  factory :invalid_user, class: User do
    username                { Faker::Internet.unique.username(specifier: 20..30) }
    email                   { Faker::Internet.unique.username }
    password                { "123456" }
    password_confirmation   { "" }
    phone_number            { Faker::Number.number(digits: 20)}
    department              { Faker::Company.industry }
  end
end