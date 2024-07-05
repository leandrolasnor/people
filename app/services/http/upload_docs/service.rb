# frozen_string_literal: true

class Http::UploadDocs::Service < Http::ApplicationService
  option :serializer, type: Interface(:serializer_for), default: -> { Http::UploadDocs::Serializer }, reader: :private
  option :monad, type: Interface(:call), default: -> { UploadDocs::Monad.new }, reader: :private

  Contract = Http::UploadDocs::Contract.new

  def call
    res = monad.call(**params)

    return [:ok, res.value!, serializer] if res.success?

    [:unprocessable_entity, res.exception.message]
  end
end
