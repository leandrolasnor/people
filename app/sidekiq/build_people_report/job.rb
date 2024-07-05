# frozen_string_literal: true

class BuildPeopleReport::Job
  include Sidekiq::Job
  sidekiq_options queue: :people

  def perform(params)
    params = JSON.parse(params, { symbolize_names: true })
    res = BuildPeopleReport::Monad.new(params[:query], params[:filename], params[:filter]).()

    RemoveFileLater::Job.perform_in(10.seconds) if res.success?
    Rails.logger.error(e.exception.backtrace) if res.failure?
  end
end
