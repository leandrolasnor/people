# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UpdatePerson::Monad do
  let(:res) { subject.(**params) }
  let(:updated) { res.value! }
  let(:contact) { proc { build(:contact, :update_person).attributes.deep_symbolize_keys.compact } }
  let(:person) do
    create(
      :person,
      :update_person,
      name: 'Nightcrawler',
      registration: '123456'
    )
  end

  describe '.call' do
    context 'on Success' do
      let(:params) do
        {
          record: person,
          id: person.id,
          name: 'Other person name',
          registration: '123asdqwe123',
          date_birth: person.date_birth,
          gender: person.gender,
          marital_status: person.marital_status,
          city_birth: person.city_birth,
          state_birth: person.state_birth,
          job_role_id: person.job_role_id,
          workspace_id: person.workspace_id,
          contacts_attributes: [
            contact.(),
            { id: person.contacts.first.id, _destroy: 1 }
          ]
        }
      end

      it 'must be able to update person' do
        expect(res).to be_success
        expect(updated.name).to eq('Other person name')
        expect(updated.registration).to eq('123asdqwe123')
        expect(updated.id).to eq(person.id)
        expect(updated.contacts.count).to eq(1)
        expect(updated.contacts.first.email).to eq(params[:contacts_attributes].first[:email])
      end
    end
  end
end
