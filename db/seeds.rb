# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# create! is like create except it raises an error for invalid users rather than returning false
# making it easier to debug 
User.create!( name: "Example SEED",
              email: "trymeout@example.com",
              password: "password",
              password_confirmation: "password",
              #Made first seed user admin for testing purposes
              admin: true,
              activated: true,
              activated_at: Time.zone.now
             )
             
99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@example.com"
    password = "password"
    
    User.create!( name: name,
                  email: email,
                  password: password,
                  password_confirmation: password,
                  admin: false,
                  activated: true,
                  activated_at: Time.zone.now
                )
end                

users = User.order(:created_at).take(6)
99.times do
    content = Faker::Lorem.sentence(5)
        users.each { |user| user.microposts.create!(content: content) }
end

             