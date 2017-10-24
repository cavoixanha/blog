# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

puts "### 1/3 ###"
users = User.create!([
                         {email: "admin@yahoo.com", password: "12345679//", password_confirmation: "12345679//", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2015-02-06 14:02:10", last_sign_in_at: "2015-02-06 14:02:10", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1"},
                         {email: "manager@yahoo.com", password: "12345679//", password_confirmation: "12345679//", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2015-02-06 14:03:01", last_sign_in_at: "2015-02-06 14:03:01", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1"},
                         {email: "customer@yahoo.com", password: "12345679//", password_confirmation: "12345679//", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2015-02-06 14:03:44", last_sign_in_at: "2015-02-06 14:03:44", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1"}
                     ])
puts "### 2/3 ###"
posts =
15.times do |i|
  begin
    Post.create(title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph, user_id: User.order("RANDOM()").first.id)
  rescue => e
    puts "Error #{e.message}"
  end
end

puts "### 3/3 ###"
comment =
15.times do |i|
  begin
    Comment.create(message: Faker::Lorem.sentence, post_id: Post.order("RANDOM()").first.id, user_id: User.order("RANDOM()").first.id)
  rescue => e
    puts "Error #{e.message}"
  end
end
