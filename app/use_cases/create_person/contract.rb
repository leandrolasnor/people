# frozen_string_literal: true

class CreatePerson::Contract < ApplicationContract
  params do
    optional(:registration).filled(:string).value(max_size?: 11)
    required(:name).filled(:string)
    optional(:date_birth).maybe(:date)
    optional(:state_birth).maybe(:string)
    optional(:city_birth).maybe(:string)
    required(:job_role_id).filled(:integer).value(gt?: 0)
    required(:workspace_id).filled(:integer).value(gt?: 0)
    optional(:marital_status).maybe(included_in?: CreatePerson::Model::Person.marital_statuses.keys)
    optional(:gender).maybe(included_in?: CreatePerson::Model::Person.genders.keys)
    optional(:contacts_attributes).array(:hash) do
      required(:email).filled(:string)
      required(:phone).filled(:string)
      required(:mobile).filled(:string)
    end
  end

  rule(:contacts_attributes) do
    value&.uniq!
  end

  rule(:contacts_attributes).each do |index:|
    if CreatePerson::Model::Contact.exists?(email: value[:email])
      key([:contacts_attributes, :email, index]).failure(:email_in_use, email: value[:email])
    end
    unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value[:email])
      key([:contacts_attributes, :email, index]).failure(:email_invalid, email: value[:email])
    end
  end

  rule(:job_role_id) do
    key.failure(:job_role_invalid) unless UpdatePerson::Model::JobRole.exists?(value)
  end

  rule(:workspace_id) do
    key(:workspace_id).failure(:workspace_invalid) unless UpdatePerson::Model::Workspace.exists?(value)
  end

  rule(:workspace_id, :job_role_id) do
    already_exist_person_on_position = CreatePerson::Model::Person.exists?(
      workspace_id: values[:workspace_id],
      job_role_id: values[:job_role_id]
    )
    key.failure(:already_exist_person_on_position) if already_exist_person_on_position
  end

  rule(:registration) do
    if values[:registration].nil?
      values[:registration] = (SecureRandom.random_number * (11**10)).round
    elsif CreatePerson::Model::Person.exists?(registration: values[:registration])
      key.failure(:registration_in_use, registration: values[:registration])
    end
  end
end
