# frozen_string_literal: true

class Http::CreatePerson::Service < Http::ApplicationService
  option :serializer, type: Interface(:serializer_for), default: -> { Http::CreatePerson::Serializer }, reader: :private
  option :transaction, type: Interface(:call), default: -> { CreatePerson::Transaction.new }, reader: :private

  def call
    transaction.call(params) do
      _1.failure :validate do |f|
        [:unprocessable_entity, f.errors.to_h]
      end

      _1.failure do |f|
        Rails.logger.error(f)
        [:internal_server_error]
      end

      _1.success do |created|
        [:created, created, serializer]
      end
    end
  end
end
