# frozen_string_literal: true

FactoryBot.define do
  Faker::Config.locale = 'pt-BR'
  factory :person do
    registration { (SecureRandom.random_number * (11**10)).round }
    name { Faker::Name.unique.name }
    date_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    state_birth { Faker::Address.state }
    city_birth { Faker::Address.city }
    marital_status { [:solteiro, :casado, :divorciado].sample }
    gender { [:F, :M].sample }

    trait :create_person do
      job_role factory: %i[job_role create_person]
      workspace factory: %i[workspace create_person]
      after(:create) { _1.contacts << create(:contact, :create_person) }

      initialize_with { CreatePerson::Model::Person.new(attributes) }
    end

    trait :destroy_person do
      job_role factory: %i[job_role destroy_person]
      workspace factory: %i[workspace destroy_person]
      after(:create) { _1.contacts << create(:contact, :destroy_person) }

      initialize_with { DestroyPerson::Model::Person.new(attributes) }
    end

    trait :update_person do
      job_role factory: %i[job_role update_person]
      workspace factory: %i[workspace update_person]
      after(:create) { _1.contacts << create(:contact, :update_person) }

      initialize_with { UpdatePerson::Model::Person.new(attributes) }
    end
  end
end
