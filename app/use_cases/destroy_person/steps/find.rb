# frozen_string_literal: true

class DestroyPerson::Steps::Find
  include Dry::Monads[:result]
  include Dry.Types()
  extend  Dry::Initializer

  option :person, type: Interface(:find), default: -> { DestroyPerson::Model::Person }, reader: :private

  def call(id:, **_)
    person.lock.find(id)
  end
end
