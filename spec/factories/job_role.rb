# frozen_string_literal: true

FactoryBot.define do
  factory :job_role do
    to_create do |instance|
      instance.attributes = JobRole.find_or_create_by(title: Faker::Job.title).attributes
      instance.instance_variable_set('@new_record', false)
    end

    trait :create_person do
      initialize_with { CreatePerson::Model::JobRole.new(attributes) }
    end

    trait :destroy_person do
      initialize_with { DestroyPerson::Model::JobRole.new(attributes) }
    end

    trait :update_person do
      initialize_with { UpdatePerson::Model::JobRole.new(attributes) }
    end
  end
end
