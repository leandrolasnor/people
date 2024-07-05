# frozen_string_literal: true

class Http::DestroyPerson::Serializer < ActiveModel::Serializer
  attributes :id, :registration, :name
  attributes :date_birth, :state_birth, :city_birth
  attributes :marital_status, :gender
  attributes :job_role_id, :workspace_id
end
