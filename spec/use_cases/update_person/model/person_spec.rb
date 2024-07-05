# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UpdatePerson::Model::Person, type: :model do
  describe 'Enums' do
    let(:enum_marital_status) { [:solteiro, :casado, :divorciado] }
    let(:enum_genders) { [:F, :M] }

    it do
      expect(subject).to define_enum_for(:marital_status).with_values(enum_marital_status)
      expect(subject).to define_enum_for(:gender).with_values(enum_genders)
    end
  end

  describe 'Associations' do
    it do
      expect(subject).to belong_to(:job_role)
      expect(subject).to belong_to(:workspace)
    end
  end

  describe 'MeiliSearch' do
    it { expect(described_class).to respond_to(:ms_raw_search) }
  end
end
