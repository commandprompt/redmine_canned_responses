module CannedResponsesHelper
  def authorize_for(controller, action)
    User.current.allowed_to?({:controller => controller, :action => action}, @project, :global => true)
  end

  def link_to_if_authorized(name, options = {}, html_options = nil, *parameters_for_method_reference)
    link_to(name, options, html_options, *parameters_for_method_reference) if authorize_for(options[:controller] || params[:controller], options[:action])
  end

  def edit_canned_response_link(canned_response, title = l(:button_edit))
    link_to_if_authorized(title,
                          { :controller => "canned_responses", :action => "edit",
                            :id => canned_response },
                          :class => "icon icon-edit").to_s.html_safe
  end

  def delete_canned_response_link(canned_response, title = l(:button_delete))
    link_to_if_authorized(title,
                          { :controller => "canned_responses", :action => "destroy",
                            :id => canned_response },
                          :class => "icon icon-del",
                          :method => :delete,
                          :confirm => l(:text_are_you_sure)).to_s.html_safe
  end

  def manage_canned_response_links(canned_response)
    [edit_canned_response_link(canned_response),
     delete_canned_response_link(canned_response)].join("\n").html_safe
  end

  def url_to_canned_responses_settings_tab
    { :controller => "projects", :action => "settings", :id => @project,
      :tab => "canned_responses" }
  end

  def link_to_all_canned_responses(title = l(:label_canned_response_view_all),
                                   project = @project)
    url = project ? url_to_canned_responses_settings_tab :
      { :controller => "canned_responses", :action => "index" }

    link_to(title, url, :class => "icon icon-multiple").html_safe
  end

  def link_to_new_canned_response(title = l(:label_new_canned_response),
                                  project = @project)
    link_to_if_authorized(title,
                          { :controller => "canned_responses", :action => "new",
                            :project_id => project },
                          :class => "icon icon-add").to_s.html_safe
  end

  def canned_response_options_for_select(project = @project)
    [project ? canned_responses_options(project.canned_responses) : "",
     canned_responses_options(CannedResponse.global)].reject(&:blank?)\
      .join("<option disabled>---</option>").html_safe
  end

  def canned_responses_options(canned_responses)
    options_for_select(canned_responses.map { |cr| [cr.title, cr.id] })
  end
end
