class ApplicationController < ActionController::Base
  include Pundit::Authorization

  def pundit_user
    Current.user
  end

  def set_refferer(path=nil)
    session[:return_to] = path
  end

  def http_referrer
    http_referrer = request.referrer
    return nil unless http_referrer or http_referrer == request.original_url
    return http_referrer
  end

  def redirect_to_refferer_or(path, options = {})
    redirect_to(session[:return_to] || path, options)
    session[:return_to] = nil
  end

end