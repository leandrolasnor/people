# frozen_string_literal: true

module Enums::Person::Gender
  extend ActiveSupport::Concern

  included do
    enum :gender, [:F, :M]
  end
end
