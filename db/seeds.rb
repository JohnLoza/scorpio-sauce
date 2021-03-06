# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
unless State.all.any?
  ActiveRecord::Base.connection.execute(IO.read("vendor/states.sql"))
end

unless City.all.any?
  ActiveRecord::Base.connection.execute(IO.read("vendor/cities.sql"))
end

warehouse = Warehouse.first
unless warehouse
  Warehouse.create!(address: "Galeana 125, col. Centro, Guadalajara, Jalisco",
    telephone: "01 800 33 4432 2312", city_id: 19597)
end

admin = User.find_by(role: User::ROLES[:admin])
unless admin
  User.create!(name: "Omar Torres", email: "omtoga@yahoo.com",
    role: User::ROLES[:admin], cellphone: "33 1409 4197", password: "StarAlpha2019",
    password_confirmation: "StarAlpha2019", warehouse_id: 1)
end

my_admin = User.find_by(email: "lozabucio.jony@gmail.com")
unless my_admin
  User.create!(name: "Erick Loza", email: "lozabucio.jony@gmail.com",
    role: User::ROLES[:admin], cellphone: "33 1293 8178", password: "Star:Alpha:19",
    password_confirmation: "Star:Alpha:19", warehouse_id: 1)
end
