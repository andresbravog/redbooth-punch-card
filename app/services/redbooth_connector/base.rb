require 'redbooth-ruby'

class RedboothConnector::Base
  attr_accessor :user

  # Initializes the Ruby object with the user holding
  # the redbooth credentials
  #
  # @param user [User] user holding the redbooth credentials
  def initialize(user)
    @user = user
  end

  protected

  # Creates RedboothRuby session based on user credentials
  #
  # @return [RedboothRuby::Session]
  def session
    @session ||= ::RedboothRuby::Session.new(token: user.credentials.token)
  end

  # Creates RedboothRuby client based on the session
  #
  # @return [RedboothRuby::Client]
  def client
    @client ||= ::RedboothRuby::Client.new(session)
  end
end
