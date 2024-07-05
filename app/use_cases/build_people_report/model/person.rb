# frozen_string_literal: true

class BuildPeopleReport::Model::Person < ApplicationRecord
  include MeiliSearch::Rails
  include Indexes::Person::Meilisearch

  class << self
    def pdf_generator(query, filter = [])
      @pdf_generator ||= BuildPeopleReport::DomainService::Report::Pdf::Person.new(self, query, filter)
    end

    def csv_generator(query, filter = [])
      @csv_generator ||= BuildPeopleReport::DomainService::Report::Csv::Person.new(self, query, filter)
    end
  end
end
