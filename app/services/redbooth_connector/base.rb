require 'redbooth-ruby'

class RedboothConnector::Base
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  protected

  def session
    @session ||= ::RedboothRuby::Session.new(token: user.credentials.token)
  end

  def client
    @client ||= ::RedboothRuby::Client.new(session)
  end
end
