# frozen_string_literal: true

class ShowPerson::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend  Dry::Initializer

  option :person, type: Interface(:find), default: -> { ShowPerson::Model::Person }, reader: :private

  def call(id)
    Try(ActiveRecord::RecordNotFound) { person.includes(:job_role, :workspace, :contacts).find(id) }
  end
end
