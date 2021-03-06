class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate

  private

  def authenticate
    if !ENV['HTTP_AUTH_USER'].blank? && !ENV['HTTP_AUTH_PASS'].blank?
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV['HTTP_AUTH_USER'] && password == ENV['HTTP_AUTH_PASS']
      end
    end
  end

end
