# frozen_string_literal: true

class Http::UpdatePerson::Service < Http::ApplicationService
  option :serializer,
         type: Interface(:serializer_for),
         default: -> { Http::UpdatePerson::Serializer }, reader: :private
  option :monad, type: Interface(:call), default: -> { UpdatePerson::Monad.new }, reader: :private

  Contract = Http::UpdatePerson::Contract.new

  def call
    res = monad.call(**params)

    return [:ok, res.value!, serializer] if res.success?

    Rails.logger.error(res.exception.full_message)
    [:unprocessable_entity, res.exception.message]
  end
end
