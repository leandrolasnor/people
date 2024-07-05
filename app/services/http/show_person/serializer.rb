# frozen_string_literal: true

class Http::ShowPerson::Serializer < ActiveModel::Serializer
  attributes :id, :name, :registration,
             :date_birth, :gender, :marital_status,
             :city_birth, :state_birth, :docs

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
