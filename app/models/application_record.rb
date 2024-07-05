# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.polymorphic_name
    name.demodulize
  end
end
