# frozen_string_literal: true

class Http::SearchPeople::Service < Http::ApplicationService
  option :monad, type: Interface(:call), default: -> { SearchPeople::Monad.new }, reader: :private

  Contract = Http::SearchPeople::Contract.new

  def call
    res = monad.call(**params)

    return [:ok, res.value!] if res.success?

    Rails.logger.error(res.exception.full_message)
    [:unprocessable_entity]
  end
end
