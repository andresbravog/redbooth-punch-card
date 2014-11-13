require 'matrix'

class RedboothConnector::TasksPunchCardDataExtractor < RedboothConnector::Base
  attr_accessor :project_id, :data

  def initialize(user, project_id)
    @project_id = project_id
    @data = {}
    super(user)
  end

  def perform
    tasks_collection = client.task(:index, project_id: project_id)

    parse_tasks_data(tasks_collection.all)

    while tasks_collection = tasks_collection.next_page do
      parse_tasks_data(tasks_collection.all)
    end

    to_hash
  end

  protected

  def parse_tasks_data(tasks)
    tasks.each do |task|
      # parse task data into @data
      time = Time.at(task.created_at).to_datetime.utc
      hour = time.hour
      wday = time.wday - 1
      @data[time.hour] ||= {}
      @data[time.hour][time.wday] ||= 0
      @data[time.hour][time.wday] += 1
    end
  end

  def data_matrix
    Matrix.build(24, 7) do |hour, wday|
      @data.fetch(hour, {}).fetch(wday, 0)
    end
  end

  def to_array
    data_array = []
    @data.each { |hour, hash| data_array += hash.collect { |wday, count|[hour, wday, count] }}
    data_array
  end

  def to_hash
    color = '#A0E5E0'
    data_array = []
    data_matrix.each_with_index do |count, hour, wday|
      next unless count > 0
      data_array << { color: color, x: hour, y: wday, z: count }
    end
    data_array
  end
end
