# frozen_string_literal: true

class DestroyPerson::Transaction
  include Dry::Transaction(container: DestroyPerson::Container)

  try :find, with: 'steps.find', catch: ActiveRecord::RecordNotFound
  try :destroy, with: 'steps.destroy', catch: StandardError
end
