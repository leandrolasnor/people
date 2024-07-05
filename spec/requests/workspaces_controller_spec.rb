# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe WorkspacesController do
  path '/v1/workspaces' do
    get('get workspaces') do
      tags 'Workspaces'
      consumes "application/json"
      produces "application/json"
      response(200, 'successful') do
        schema type: :array, items: {
          type: :object, properties: {
            id: { type: :integer, example: 2343 },
            title: { type: :string, example: "Department" }
          }
        }
        run_test!
      end
    end
  end
end
