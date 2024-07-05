# frozen_string_literal: true

class SearchPeople::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend  Dry::Initializer

  option :person, type: Interface(:where), default: -> { SearchPeople::Model::Person }, reader: :private

  def call(query:, filter:, page:, per_page:, sort: 'name:asc', **_)
    Try[MeiliSearch::ApiError] do
      person.ms_raw_search(query, filter: filter, page: page, hits_per_page: per_page, sort: [sort])
    end
  end
end
