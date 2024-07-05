# frozen_string_literal: true

class Http::CreatePerson::Serializer < ActiveModel::Serializer
  attributes :id, :registration, :name
  attributes :date_birth, :state_birth, :city_birth
  attributes :marital_status, :gender

  belongs_to :job_role
  belongs_to :workspace
  has_many :contacts

  class JobRoleSerializer < ActiveModel::Serializer
    attributes :id, :title
  end

  class WorkspaceSerializer < ActiveModel::Serializer
    attributes :id, :title
  end

  class ContactSerializer < ActiveModel::Serializer
    attributes :id, :email, :phone, :mobile
  end
end
