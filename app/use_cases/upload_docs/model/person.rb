# frozen_string_literal: true

class UploadDocs::Model::Person < ApplicationRecord
  include Enums::Person::Gender
  include Enums::Person::MaritalStatus

  belongs_to :job_role
  belongs_to :workspace
  has_many :contacts
  has_many_attached :docs
end
