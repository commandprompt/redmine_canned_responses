module RedmineCannedResponses
  class ViewHooks < Redmine::Hook::ViewListener
    unloadable

    render_on :view_issues_form_details_bottom,
      :partial => 'hooks/canned_responses_issue_insert'
  end
end
