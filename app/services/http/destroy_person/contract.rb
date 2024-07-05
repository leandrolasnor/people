# frozen_string_literal: true

class Http::DestroyPerson::Contract < ApplicationContract
  params do
    required(:id).filled(:integer).value(gt?: 0)
  end
end
