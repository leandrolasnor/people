# frozen_string_literal: true

class SearchPeople::Model::Person < ApplicationRecord
  include MeiliSearch::Rails
  include Indexes::Person::Meilisearch
end
