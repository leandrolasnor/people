# frozen_string_literal: true

class Http::DestroyPerson::Service < Http::ApplicationService
  option :serializer, type: Interface(:serializer_for), default: -> {
                                                                   Http::DestroyPerson::Serializer
                                                                 }, reader: :private
  option :transaction, type: Interface(:call), default: -> { DestroyPerson::Transaction.new }, reader: :private

  Contract = Http::DestroyPerson::Contract.new

  def call
    transaction.call(params) do
      _1.failure :find do |f|
        [:not_found, f.message]
      end

      _1.failure :destroy do |f|
        [:unprocessable_entity, f.message]
      end

      _1.failure do |f|
        Rails.logger.error(f)
        [:internal_server_error]
      end

      _1.success do |destroyed|
        [:ok, destroyed, serializer]
      end
    end
  end
end
