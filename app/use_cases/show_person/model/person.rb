# frozen_string_literal: true

class ShowPerson::Model::Person < ApplicationRecord
  acts_as_paranoid
  include Enums::Person::Gender
  include Enums::Person::MaritalStatus

  belongs_to :job_role
  belongs_to :workspace
  has_many :contacts
  has_many_attached :docs
end
