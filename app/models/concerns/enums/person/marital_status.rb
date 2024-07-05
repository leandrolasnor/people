# frozen_string_literal: true

module Enums::Person::MaritalStatus
  extend ActiveSupport::Concern

  included do
    enum :marital_status, [:solteiro, :casado, :divorciado]
  end
end
