# frozen_string_literal: true

module Indexes::Person::Meilisearch
  extend ActiveSupport::Concern

  included do
    meilisearch index_uid: :person do
      attribute :name
      attribute :registration
      attribute :date_birth
      attribute :gender
      attribute :workspace do
        workspace.title rescue nil
      end
      attribute :job_role do
        job_role.title rescue nil
      end
      displayed_attributes [:id, :name, :registration, :date_birth, :gender, :workspace, :job_role]
      searchable_attributes [:name, :registration]
      sortable_attributes [:name]
      filterable_attributes [:gender, :workspace, :job_role]
    end
  end
end
