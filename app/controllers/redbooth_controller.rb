class RedboothController < ApplicationController
  before_action :authenticate_user!
  before_action :load_project

  def punch_card
    # Punch puch_card
    @data = RedboothConnector::TasksPunchCardDataExtractor.new(current_user, params[:project_id]).perform
  end

  protected

  # BadRequest if no project_id given
  def load_project
    head :bad_request and return unless params[:project_id].present?
  end
end
