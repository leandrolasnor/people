# frozen_string_literal: true

class ApplicationCable::Connection < ActionCable::Connection::Base
  identified_by :token

  def connect
    self.token = 'token'
  end
end
