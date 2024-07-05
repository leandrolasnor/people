# frozen_string_literal: true

class DestroyPerson::Steps::Destroy
  include Dry::Monads[:result]
  include Dry::Events::Publisher[:person_destroyed]

  register_event 'person.destroyed'

  def call(person)
    person.transaction do
      person.remove_from_index!
      destroyed = person.destroy!
      publish('person.destroyed', person: destroyed)
      destroyed
    end
  end
end
