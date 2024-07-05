# frozen_string_literal: true

require 'rails_helper'
RSpec.describe DestroyPerson::Steps::Find do
  describe '.call' do
    subject { described_class.new.(id: id) }

    context 'on Success' do
      let(:person) { create(:person, :destroy_person) }
      let(:id) { person.id }

      it { is_expected.to be_a(DestroyPerson::Model::Person) }
    end

    context 'on Failure' do
      let(:id) { 0 }

      it do
        expect { subject }.to raise_error(
          ActiveRecord::RecordNotFound,
          "Couldn't find DestroyPerson::Model::Person with 'id'=0 [WHERE \"people\".\"deleted_at\" IS NULL]"
        )
      end
    end
  end
end
