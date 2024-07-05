# frozen_string_literal: true

class UpdatePerson::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend  Dry::Initializer

  option :person, type: Interface(:find), default: -> { UpdatePerson::Model::Person }, reader: :private

  def call(record:, **params)
    Try do
      record.transaction do
        record.update!(params.to_h.except(:id))
        record
      end
    end
  end
end
