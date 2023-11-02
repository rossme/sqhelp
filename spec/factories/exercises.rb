# spec/factories/exercises.rb

FactoryBot.define do
  factory(:exercise) do
    title { 'Test exercise title' }
    description { 'Test exercise description' }
    query { 'SELECT * FROM customers' }
    difficulty { 1 }
  end
end
