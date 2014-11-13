class RedboothConnector::ProjectsLister < RedboothConnector::Base

  # Fetches all Redbooth projects where user belongs
  #
  # @return [Array(RedboothRuby::Project)]
  def perform
    projects_collection = client.project(:index, user_id: user_id)
    projects = projects_collection.all

    while projects_collection = projects_collection.next_page do
      projects << projects_collection.all
    end

    projects.flatten!
  end

  protected

  # Current user id
  #
  # @return [Integer]
  def user_id
    client.me(:show).id
  end

end
