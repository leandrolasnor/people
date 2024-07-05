# frozen_string_literal: true

class UpdatePerson::Model::Person < ApplicationRecord
  acts_as_paranoid
  include Enums::Person::Gender
  include Enums::Person::MaritalStatus
  include MeiliSearch::Rails
  include Indexes::Person::Meilisearch

  belongs_to :job_role
  belongs_to :workspace
  has_many_attached :docs
  has_many :contacts
  accepts_nested_attributes_for :contacts, allow_destroy: true
end
