class HomeController < ApplicationController
  before_action :load_current_user

  def index
    # index
  end

  protected

  def load_current_user
    @current_user = current_user
  end
end
