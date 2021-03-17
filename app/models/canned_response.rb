class CannedResponse < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :title, :text

  scope :global, lambda { where(:project_id => nil) }
  default_scope { order(:title) }

  def global?
    project.nil?
  end
end
