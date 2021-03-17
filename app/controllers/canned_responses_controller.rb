class CannedResponsesController < ApplicationController
  unloadable

  before_filter :find_project

  before_filter :require_admin_if_global, :except => :insert
  before_filter :authorize_unless_global, :only => :insert

  layout :select_layout

  def index
  end

  def show
  end

  def new
    @canned_response = @canned_responses.new
  end

  def edit
  end

  def create
    @canned_response = @canned_responses.new
    if @canned_response.update_attributes(cr_params)
      flash[:notice] = l(:notice_canned_response_created)
      redirect_to @canned_response
    else
      render :new
    end
  end

  def update
    if @canned_response.update_attributes(cr_params)
      flash[:notice] = l(:notice_canned_response_updated)
      redirect_to @canned_response
    else
      render :edit
    end
  end

  def destroy
    @canned_response.destroy
    flash[:notice] = l(:notice_canned_response_deleted)
    redirect_to(@project ? url_to_canned_responses_settings_tab :
                { :action => :index })
  end

  def preview
    @text = cr_params[:text]
    render :partial => 'common/preview'
  end

  def insert
    render :text => @canned_response.text
  end

  private

  def cr_params
    params.require(:canned_response).permit(:title, :text)
  end

  include CannedResponsesHelper

  def select_layout
    @project ? 'base' : 'admin'
  end

  def find_project
    if params[:project_id].present?
      @project = Project.find(params[:project_id])
      @canned_responses = @project.canned_responses
    else
      @canned_responses = CannedResponse
    end
    if params[:id].present?
      @canned_response = @canned_responses.find(params[:id])
      if !@project && @canned_response.project_id
        @project = Project.find(@canned_response.project_id)
      end
    end
    @canned_responses = CannedResponse.global unless @project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def require_admin_if_global
    require_admin unless @project
  end

  def authorize_unless_global
    authorize unless @canned_response.global?
  end
end
