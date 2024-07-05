# frozen_string_literal: true

class DestroyPerson::Container
  extend Dry::Container::Mixin

  register 'steps.find', -> { DestroyPerson::Steps::Find.new }
  register 'steps.destroy', -> { DestroyPerson::Steps::Destroy.new }
end
