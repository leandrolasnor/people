# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe JobRolesController do
  path '/v1/job_roles' do
    get('get job roles') do
      tags 'Job Roles'
      consumes "application/json"
      produces "application/json"
      response(200, 'successful') do
        schema type: :array, items: {
          type: :object, properties: {
            id: { type: :integer, example: 8738 },
            title: { type: :string, example: "Engineer" }
          }
        }
        run_test!
      end
    end
  end
end
