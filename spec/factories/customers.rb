# spec/factories/customers.rb

FactoryBot.define do
  factory(:customer) do
    customer_name { Faker::Name.name }
    phone_number { Faker::PhoneNumber.phone_number }
    address { Faker::Address.full_address }
    email { Faker::Internet.email }
  end
end
