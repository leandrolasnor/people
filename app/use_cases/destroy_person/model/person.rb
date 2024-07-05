# frozen_string_literal: true

class DestroyPerson::Model::Person < ApplicationRecord
  acts_as_paranoid
  include Enums::Person::Gender
  include Enums::Person::MaritalStatus
  include MeiliSearch::Rails
  include Indexes::Person::Meilisearch

  belongs_to :job_role
  belongs_to :workspace
  has_many_attached :docs, dependent: :detach
  has_many :contacts, dependent: :destroy
end
