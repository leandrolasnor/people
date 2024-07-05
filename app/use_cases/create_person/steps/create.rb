# frozen_string_literal: true

class CreatePerson::Steps::Create
  include Dry::Monads[:result]
  include Dry.Types()
  extend  Dry::Initializer

  option :person, type: Interface(:create), default: -> { CreatePerson::Model::Person }, reader: :private

  def call(params)
    person.transaction do
      created = person.create do
        _1.registration = params[:registration]
        _1.name = params[:name]
        _1.date_birth = params[:date_birth]
        _1.city_birth = params[:city_birth]
        _1.state_birth = params[:state_birth]
        _1.marital_status = params[:marital_status]
        _1.gender = params[:gender]
        _1.workspace_id = params[:workspace_id]
        _1.job_role_id = params[:job_role_id]
        _1.contacts_attributes = params[:contacts_attributes] if params[:contacts_attributes].present?
      end
      created
    end
  end
end
