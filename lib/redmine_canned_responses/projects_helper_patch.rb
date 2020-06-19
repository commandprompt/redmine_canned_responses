module RedmineCannedResponses
  module ProjectsHelperPatch
    unloadable

    def self.included(base)
      base.class_eval do
        alias_method :project_settings_tabs_without_canned_responses, :project_settings_tabs
        alias_method :project_settings_tabs, :project_settings_tabs_with_canned_responses
      end
    end

    def project_settings_tabs_with_canned_responses
      project_settings_tabs_without_canned_responses.tap do |tabs|
        if User.current.allowed_to?(:manage_canned_responses, @project)
          tabs.push({ :name => 'canned_responses',
                      :action => :manage_project_canned_responses,
                      :partial => 'canned_responses/project_settings',
                      :label => :label_canned_response_plural })
        end
      end
    end
  end
end
