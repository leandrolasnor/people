# frozen_string_literal: true

require 'rails_helper'
RSpec.describe BuildPeopleReport::Model::Person, type: :model do
  it 'respond_to' do
    expect(described_class).to respond_to(:ms_raw_search)
    expect(described_class).to respond_to(:pdf_generator)
    expect(described_class).to respond_to(:csv_generator)
  end
end
