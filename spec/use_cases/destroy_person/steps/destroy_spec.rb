# frozen_string_literal: true

require 'rails_helper'
RSpec.describe DestroyPerson::Steps::Destroy do
  describe '.call' do
    let(:call) { described_class.new.(subject) }

    context 'on Success' do
      subject { create(:person, :destroy_person) }

      before { call }

      it { is_expected.to be_deleted }
    end
  end
end
