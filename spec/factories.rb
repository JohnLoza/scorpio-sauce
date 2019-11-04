FactoryBot.define do
  factory :user, class: :User do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user_#{n}@example.com"}
    sequence(:email_confirmation) { |n| "user_#{n}@example.com"}
    cellphone { "331 293 8178" }
    password { "foobar" }
    password_confirmation { "foobar" }
    role {}
    warehouse {}

    factory :admin do
      role { User::ROLES[:admin] }
    end
  end

  factory :warehouse do
    city_id { 19597 }
    address { "Galeana 125, centro" }
    telephone { "333 2938 1756" }
  end

  factory :client do
    user {}
    city_id { 19597 }
    sequence(:name) { |n| "Client #{n}"}
    telephone { "33 1293 8178" }
    address { "Bartolomé Gutiérrez 1252" }
    colony { "Vistas del sur" }
    zc { "44970" }
    lat { "20.617043" }
    lng { "103.366206" }
  end
end
