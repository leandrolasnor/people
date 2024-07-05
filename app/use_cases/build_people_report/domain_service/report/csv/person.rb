# frozen_string_literal: true

require 'csv'

class BuildPeopleReport::DomainService::Report::Csv::Person
  include Dry.Types()
  extend Dry::Initializer

  param :searcher, type: Interface(:ms_raw_search), reader: :private
  param :query, type: String, default: -> { '' }, reader: :private
  param :filter, type: Array, default: -> { [] }, reader: :private
  option :rows, type: Array, default: -> { [] }, reader: :private
  option :hits_per_page, type: Integer, default: -> { 1000 }, reader: :private
  option :facets, type: Array, default: -> { [:gender] }, reader: :private
  option :sort, type: Array, default: -> { ['name:asc'] }, reader: :private
  option :page, type: Integer, default: -> { 1 }, reader: :private
  option :content, type: Hash,
                   default: -> {
                     searcher.ms_raw_search(query, hits_per_page: hits_per_page, filter: filter, facets: facets, sort: sort, page: page)
                   },
                   reader: :private

  def report
    content.deep_symbolize_keys!
    header
    body
    rows.map(&:to_csv).join
  end

  private

  def header
    rows.push(content[:hits].first.keys - [:id])
  end

  def body
    content[:hits].each do
      rows.push(_1.except(:id).values)
    end
  end
end
