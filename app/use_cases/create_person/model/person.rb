# frozen_string_literal: true

class CreatePerson::Model::Person < ApplicationRecord
  include Enums::Person::Gender
  include Enums::Person::MaritalStatus
  include MeiliSearch::Rails
  include Indexes::Person::Meilisearch

  belongs_to :job_role
  belongs_to :workspace
  has_many :contacts
  has_many_attached :docs
  accepts_nested_attributes_for :contacts
end
