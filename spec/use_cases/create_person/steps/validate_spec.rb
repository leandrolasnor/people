# frozen_string_literal: true

require 'rails_helper'
RSpec.describe CreatePerson::Steps::Validate do
  describe '.call' do
    let(:call) { subject.(params) }

    context 'on Success' do
      let(:job_role) { create(:job_role, :create_person) }
      let(:workspace) { create(:workspace, :create_person) }
      let(:params) do
        {
          name: 'Forrest Gump',
          registration: '1336670851',
          date_birth: '29/12/1966',
          state_birth: 'Goiás',
          city_birth: 'Goiânia',
          job_role_id: job_role.id,
          workspace_id: workspace.id,
          gender: 'M'
        }
      end

      it 'must be able to validate person params' do
        expect(call).to be_success
      end
    end

    context 'on Failure' do
      let(:person) { create(:person, :create_person) }
      let(:params) do
        {
          name: 6,
          registration: person.registration,
          date_birth: 'String',
          state_birth: 0,
          city_birth: true,
          job_role_id: 9999,
          workspace_id: 0,
          gender: 'R',
          marital_status: :enrolado
        }
      end
      let(:expected_errors) do
        {
          name: ['must be a string'],
          registration: ["Registration in use - #{person.registration}"],
          date_birth: ['must be a date'],
          state_birth: ['must be a string'],
          city_birth: ['must be a string'],
          job_role_id: ['Job role invalid'],
          workspace_id: ['must be greater than 0'],
          gender: ['must be one of: F, M'],
          marital_status: ["must be one of: solteiro, casado, divorciado"]
        }
      end

      it 'must be able to get errors from contract' do
        expect(call).to be_failure
        expect(call.failure.errors.to_h).to match(expected_errors)
      end
    end
  end
end
