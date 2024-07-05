# frozen_string_literal: true

require 'rails_helper'
RSpec.describe CreatePerson::Steps::Create do
  describe '.call' do
    let(:call) { subject.(params) }
    let(:job_role) { create(:job_role, :create_person) }
    let(:workspace) { create(:workspace, :create_person) }
    let(:contact) { proc { build(:contact, :create_person).attributes.deep_symbolize_keys.compact } }
    let(:params) do
      {
        name: 'Forrest Gump',
        registration: '1336670851',
        date_birth: '29/12/1966',
        state_birth: 'Goiás',
        city_birth: 'Goiânia',
        job_role_id: job_role.id,
        workspace_id: workspace.id,
        gender: 'M',
        contacts_attributes: [contact.(), contact.()]
      }
    end

    context 'on Success' do
      before { call }

      it 'must be able to create a person' do
        expect(call).to be_a(CreatePerson::Model::Person)
        expect(call.name).to eq('Forrest Gump')
        expect(call.registration).to eq('1336670851')
        expect(call.date_birth.strftime("%d/%m/%Y")).to eq('29/12/1966')
        expect(call.state_birth).to eq('Goiás')
        expect(call.city_birth).to eq('Goiânia')
        expect(call.job_role.title).to eq(job_role.title)
        expect(call.workspace.title).to eq(workspace.title)
        expect(call.gender).to eq('M')
        expect(call.contacts.count).to eq(params[:contacts_attributes].count)
      end
    end
  end
end
