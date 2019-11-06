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

    factory :admin_staff_user do
      role { User::ROLES[:admin_staff] }
    end

    factory :warehouse_user do
      role { User::ROLES[:warehouse] }
    end
  end

  factory :warehouse do
    city_id { 19597 }
    address { "Galeana 125, centro" }
    telephone { "333 2938 1756" }
  end

  factory :product do
    name { "Salsa scorpio 225ml" }
    retail_price { "25.00" }
    half_wholesale_price { "23.00" }
    required_units_half_wholesale { 10 }
    wholesale_price { "21.00" }
    required_units_wholesale { 20 }

    factory :inactive_product do
      deleted_at { Time.now }
    end
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
