# frozen_string_literal: true

class Person < ApplicationRecord
  include Enums::Person::MaritalStatus
  include Enums::Person::Gender
end
