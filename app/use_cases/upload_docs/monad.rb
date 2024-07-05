# frozen_string_literal: true

class UploadDocs::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend  Dry::Initializer

  def call(record:, file:, **_)
    Try do
      record.transaction do
        record.docs.attach(file)
        record
      end
    end
  end
end
