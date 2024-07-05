# frozen_string_literal: true

class WorkspacesController < BaseController
  def index
    render json: CreatePerson::Model::Workspace.select(:id, :title), status: :ok
  end
end
