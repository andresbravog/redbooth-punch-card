class HomeController < ApplicationController
  before_action :load_current_user

  def index
    # index
    if @current_user.present?
      @projects = RedboothConnector::ProjectsLister.new(@current_user).perform.sort_by(&:name)
    end
  end

  protected

  def load_current_user
    @current_user = current_user
  end
end
