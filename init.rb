Redmine::Plugin.register :redmine_canned_responses do
  name 'Redmine Canned Responses plugin'
  author 'Alex Shulgin <ash@commandprompt.com>'
  description 'Store and use prepared (canned) responses, per-project or globally.'
  version '0.3.0'
  requires_redmine '3.0.0'
  url 'http://github.com/commandprompt/redmine_canned_responses'
#  author_url 'http://example.com/about'

  project_module :canned_responses do
    permission :manage_canned_responses,
      :canned_responses => [:index, :show, :preview, :new, :edit,
                            :create, :update, :destroy]
    permission :use_canned_responses, :canned_responses => [:insert]
  end

  menu :admin_menu, :canned_responses,
    { :controller => 'canned_responses', :action => 'index' },
    :caption => :label_canned_response_plural,
    :html => { :class => 'canned_responses' }
end

require_dependency 'redmine_canned_responses/view_hooks'

prepare_block = Proc.new do
  Project.send(:include, RedmineCannedResponses::ProjectPatch)
  ProjectsHelper.send(:include, RedmineCannedResponses::ProjectsHelperPatch)
  ProjectsController.send(:include, RedmineCannedResponses::ProjectsControllerPatch)
  IssuesController.send(:include, RedmineCannedResponses::IssuesControllerPatch)
end

if Rails.env.development?
  ActionDispatch::Reloader.to_prepare { prepare_block.call }
else
  prepare_block.call
end
