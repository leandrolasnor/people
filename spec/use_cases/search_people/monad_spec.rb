# frozen_string_literal: true

require 'rails_helper'
RSpec.describe SearchPeople::Monad do
  let(:call) do
    subject.(
      query: query,
      filter: filter,
      page: page,
      per_page: per_page,
      sort: sort
    )
  end

  describe '.call' do
    let(:query) { 'oi' }
    let(:filter) { ["workspace = 'Information Technology'"] }
    let(:page) { 1 }
    let(:per_page) { 2 }
    let(:sort) { 'name:asc' }

    before do
      allow(SearchPeople::Model::Person)
        .to receive(:ms_raw_search)
        .with(
          query,
          filter: filter,
          page: page,
          hits_per_page: per_page,
          sort: [sort]
        )
      call
    end

    it 'must be able to call search method' do
      expect(SearchPeople::Model::Person).
        to have_received(:ms_raw_search).
        with(
          query,
          filter: filter,
          page: page,
          hits_per_page: per_page,
          sort: [sort]
        )
    end
  end
end
