# frozen_string_literal: true

class Http::UploadDocs::Contract < ApplicationContract
  params do
    required(:id).filled(:integer).value(gt?: 0)
    required(:file).filled(type?: ActionDispatch::Http::UploadedFile)
  end

  rule(:id) do
    values[:record] = UploadDocs::Model::Person.includes(:job_role, :workspace, :contacts).find value
  rescue ActiveRecord::RecordNotFound
    key.failure(:record_not_found)
  end
end
