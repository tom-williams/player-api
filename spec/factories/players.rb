FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :firstname do |n|
    "Firstname#{n}"
  end

  sequence :lastname do |n|
    "Lastname#{n}"
  end

  factory :player do
    firstname
    lastname
    email
    club { nil }
    position { nil }
    date_of_birth { nil }
    password { 'testtest' }
  end
end
