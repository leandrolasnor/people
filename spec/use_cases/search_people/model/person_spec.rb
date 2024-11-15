# frozen_string_literal: true

require 'rails_helper'
RSpec.describe SearchPeople::Model::Person, type: :model do
  describe 'MeiliSearch' do
    it { expect(described_class).to respond_to(:ms_raw_search) }
  end
end
