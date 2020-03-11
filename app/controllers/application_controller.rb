class ApplicationController < ActionController::Base
  # -- breadcrumbs
  include Wobapphelpers::Breadcrumbs
  before_action :add_breadcrumb_index, only: [:index]


  # -- flash responder
  self.responder = Wobapphelpers::Responders
  respond_to :html, :json, :js

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # -- authorization
  load_and_authorize_resource :unless => :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from CanCan::AccessDenied, :with => :access_denied

protected

  def access_denied(exception)
    flash.now[:error] = "Keine Berechtigung für diese Aktion!"
    if Rails.env == 'development'
      Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    end
    respond_to do |format|
      format.js   { render 'errors/access_denied' }
      format.html {
        add_breadcrumb("Fehlerseite", '#')
        render 'errors/show_error', :status => 401
      }
    end
  end

  def record_not_found (exception)
    flash[:error] = exception.message
    respond_to do |format|
      format.js { render 'errors/show_error' }
      format.html do
        if @controller.respond_to? :index
          redirect_to url_for(:action => 'index')
        else
          render 'errors/show_error', :status => :unprocessable_entity
        end
      end
    end
  end

 def submit_parms
    [ "bci", "utf8", "authenticity_token", "commit", "format" ]
  end

end
