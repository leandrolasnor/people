# frozen_string_literal: true

module ::Json
  module Parse
    module Helper
      def parsed_body
        JSON.parse(response.body, symbolize_names: true) if response.body.presence
      end
    end
  end
end

RSpec.configure do |config|
  config.include(Json::Parse::Helper, type: :request)
end
