# frozen_string_literal: true

class JobRolesController < BaseController
  def index
    render json: CreatePerson::Model::JobRole.select(:id, :title), status: :ok
  end
end
