# frozen_string_literal: true

class BuildPeopleReport::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend  Dry::Initializer

  param :query, type: String, reader: :private
  param :filename, type: String, reader: :private
  param :filter, type: Array, default: -> { [] }, reader: :private
  option :person, type: Interface(:ms_raw_search), default: -> { BuildPeopleReport::Model::Person }, reader: :private

  def call
    Try[MeiliSearch::ApiError] do
      content = case filename
                when /.\.pdf$/i
                  person.pdf_generator(query, filter).report
                when /.\.csv$/i
                  person.csv_generator(query, filter).report
                else
                  return
                end

      if content
        Rails.root.join(filename).delete rescue nil
        Rails.root.join(filename).binwrite(content)
        ActionCable.server.broadcast('token', { type: "PEOPLE_REPORT_BUILT", payload: filename })
      end
    end
  end
end
