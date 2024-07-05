# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.cell_phone_in_e164 }
    mobile { Faker::PhoneNumber.cell_phone_in_e164 }

    trait :create_person do
      initialize_with { CreatePerson::Model::Contact.new(attributes) }
    end

    trait :update_person do
      initialize_with { UpdatePerson::Model::Contact.new(attributes) }
    end

    trait :destroy_person do
      initialize_with { DestroyPerson::Model::Contact.new(attributes) }
    end
  end
end
