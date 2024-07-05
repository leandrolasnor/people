# frozen_string_literal: true

FactoryBot.define do
  factory :workspace do
    to_create do |instance|
      instance.attributes = Workspace.find_or_create_by(title: Faker::Company.department).attributes
      instance.instance_variable_set('@new_record', false)
    end

    trait :create_person do
      initialize_with { CreatePerson::Model::Workspace.new(attributes) }
    end

    trait :destroy_person do
      initialize_with { DestroyPerson::Model::Workspace.new(attributes) }
    end

    trait :update_person do
      initialize_with { UpdatePerson::Model::Workspace.new(attributes) }
    end
  end
end
