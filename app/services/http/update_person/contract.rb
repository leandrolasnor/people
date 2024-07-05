# frozen_string_literal: true

class Http::UpdatePerson::Contract < ApplicationContract
  params do
    required(:id).filled(:integer).value(gt?: 0)
    optional(:registration).filled(:string).value(max_size?: 11)
    required(:name).filled(:string)
    optional(:date_birth).maybe(:date)
    optional(:state_birth).maybe(:string)
    optional(:city_birth).maybe(:string)
    required(:job_role_id).filled(:integer).value(gt?: 0)
    required(:workspace_id).filled(:integer).value(gt?: 0)
    optional(:marital_status).maybe(included_in?: UpdatePerson::Model::Person.marital_statuses.keys)
    optional(:gender).maybe(included_in?: UpdatePerson::Model::Person.genders.keys)
    optional(:contacts_attributes).array(:hash) do
      optional(:id).filled(:integer)
      required(:email).filled(:string)
      required(:phone).filled(:string)
      required(:mobile).filled(:string)
      optional(:_destroy).filled(:integer)
    end
  end

  rule(:contacts_attributes) do
    value&.uniq!
  end

  rule(:contacts_attributes).each do |index:|
    if UpdatePerson::Model::Contact.where.not(id: value[:id]).exists?(email: value[:email])
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
    already_exist_person_on_position = UpdatePerson::Model::Person.where.not(id: values[:id]).exists?(
      workspace: values[:workspace_id],
      job_role: values[:job_role_id]
    )
    key.failure(:already_exist_person_on_position) if already_exist_person_on_position
  end

  rule(:registration) do
    key.failure(:registration_in_use, registration: value) if UpdatePerson::Model::Person
      .where.not(id: values[:id])
      .exists?(registration: value)
  end

  rule(:id) do
    values[:record] = UpdatePerson::Model::Person.lock.find(value)
  rescue ActiveRecord::RecordNotFound
    key.failure(:record_not_found)
  end
end
