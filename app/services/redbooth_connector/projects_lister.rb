class RedboothConnector::ProjectsLister < RedboothConnector::Base

  def perform
    projects_collection = client.project(:index)
    projects = projects_collection.all

    while projects_collection = projects_collection.next_page do
      projects << projects_collection.all
    end

    projects.flatten!
  end

end
