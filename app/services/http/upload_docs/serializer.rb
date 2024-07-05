# frozen_string_literal: true

class Http::UploadDocs::Serializer < ActiveModel::Serializer
  attributes :id, :registration, :name
  attributes :date_birth, :state_birth, :city_birth
  attributes :marital_status, :gender, :docs

  belongs_to :job_role
  belongs_to :workspace
  has_many :contacts

  def docs
    object.docs.map { { id: _1.id, filename: _1.filename.to_s } }
  end

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
