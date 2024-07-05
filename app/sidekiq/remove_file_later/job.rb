# frozen_string_literal: true

class RemoveFileLater::Job
  include Sidekiq::Job

  sidekiq_options queue: :people

  def perform
    Rails.root.join('people.pdf').delete rescue nil
    Rails.root.join('people.csv').delete rescue nil
  end
end
