# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Http::UpdatePerson::Contract do
  subject { described_class.new.(params) }

  let(:people) { create_list(:person, 2, :update_person) }
  let(:contact) { proc { build(:contact, :update_person).attributes.deep_symbolize_keys.compact } }
  let(:job_role) { create(:job_role, :update_person) }
  let(:workspace) { create(:workspace, :update_person) }
  let(:contacts_attributes) { [contact.(), contact.(), contact.(), contact.()] }

  let(:params) do
    {
      id: people.first.id,
      name: 'Kratos',
      registration: '12343123324',
      workspace_id: workspace.id,
      job_role_id: job_role.id,
      contacts_attributes: contacts_attributes
    }
  end

  context 'on success' do
    context 'when data is correct' do
      it do
        expect(subject).to be_success
      end
    end

    context 'when there are contacts_attributes repeted' do
      let(:c) { contact.() }
      let(:contacts_attributes) { [c, c, contact.(), contact.()] }

      it do
        expect(subject).to be_success
        expect(subject.to_h[:contacts_attributes].count).to eq(contacts_attributes.count - 1)
      end
    end
  end

  context 'on failure' do
    context 'when contacts_attributes have a format problem' do
      context 'when email in use' do
        let(:contacts_attributes) do
          [
            contact.(),
            contact.(),
            contact.(),
            contact.().merge(email: people.second.contacts.first.email)
          ]
        end
        let(:expected_errors) do
          {
            contacts_attributes: { email: { 3 => ["Email in use - #{people.second.contacts.first.email}"] } }
          }
        end

        it do
          expect(subject).to be_failure
          expect(subject.errors.to_h).to match(expected_errors)
        end
      end

      context 'when email not valid' do
        let(:contacts_attributes) do
          [
            contact.(),
            contact.(),
            contact.(),
            contact.().merge(email: 'Email invalido')
          ]
        end
        let(:expected_errors) do
          {
            contacts_attributes: { email: { 3 => ["Email not valid - Email invalido"] } }
          }
        end

        it do
          expect(subject).to be_failure
          expect(subject.errors.to_h).to match(expected_errors)
        end
      end

      context 'when contacts_attributes is a object' do
        let(:contacts_attributes) { contact.() }
        let(:expected_errors) { { contacts_attributes: ['must be an array'] } }

        it do
          expect(subject).to be_failure
          expect(subject.errors.to_h).to match(expected_errors)
        end
      end

      context 'when contacts_attributes is a array of string' do
        let(:contacts_attributes) { ['string1', 'string2'] }
        let(:expected_errors) { { contacts_attributes: { 0 => ["must be a hash"], 1 => ["must be a hash"] } } }

        it do
          expect(subject).to be_failure
          expect(subject.errors.to_h).to match(expected_errors)
        end
      end
    end

    context 'when job role is zero' do
      let(:params) do
        {
          id: people.first.id,
          name: 'Kratos',
          registration: '12343123324',
          workspace_id: workspace.id,
          job_role_id: 0,
          contacts_attributes: contacts_attributes
        }
      end
      let(:expected_errors) { { job_role_id: ["must be greater than 0"] } }

      it do
        expect(subject).to be_failure
        expect(subject.errors.to_h).to match(expected_errors)
      end
    end

    context 'when job role is not valid' do
      let(:params) do
        {
          id: people.first.id,
          name: 'Kratos',
          registration: '12343123324',
          workspace_id: workspace.id,
          job_role_id: 23098347327091283,
          contacts_attributes: contacts_attributes
        }
      end
      let(:expected_errors) { { job_role_id: ["Job role invalid"] } }

      it do
        expect(subject).to be_failure
        expect(subject.errors.to_h).to match(expected_errors)
      end
    end

    context 'when workspace is zero' do
      let(:params) do
        {
          id: people.first.id,
          name: 'Kratos',
          registration: '12343123324',
          workspace_id: 0,
          job_role_id: job_role.id,
          contacts_attributes: contacts_attributes
        }
      end
      let(:expected_errors) { { workspace_id: ["must be greater than 0"] } }

      it do
        expect(subject).to be_failure
        expect(subject.errors.to_h).to match(expected_errors)
      end
    end

    context 'when workspace is not valid' do
      let(:params) do
        {
          id: people.first.id,
          name: 'Kratos',
          registration: '12343123324',
          workspace_id: 3412323098,
          job_role_id: job_role.id,
          contacts_attributes: contacts_attributes
        }
      end
      let(:expected_errors) { { workspace_id: ["Workspace invalid"] } }

      it do
        expect(subject).to be_failure
        expect(subject.errors.to_h).to match(expected_errors)
      end
    end

    context 'when already exist person on position' do
      let(:params) do
        {
          id: people.first.id,
          name: 'Kratos',
          registration: '12343123324',
          workspace_id: people.second.workspace_id,
          job_role_id: people.second.job_role_id,
          contacts_attributes: contacts_attributes
        }
      end

      let(:expected_errors) { { workspace_id: ["This position is occupied"] } }

      it do
        expect(subject).to be_failure
        expect(subject.errors.to_h).to match(expected_errors)
      end
    end

    context 'when registration in use' do
      let(:params) do
        {
          id: people.first.id,
          name: 'Kratos',
          registration: people.second.registration,
          workspace_id: workspace.id,
          job_role_id: job_role.id,
          contacts_attributes: contacts_attributes
        }
      end

      let(:expected_errors) { { registration: ["Registration in use - #{people.second.registration}"] } }

      it do
        expect(subject).to be_failure
        expect(subject.errors.to_h).to match(expected_errors)
      end
    end
  end
end
