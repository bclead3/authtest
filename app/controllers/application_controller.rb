class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    resource_out = "\/#{resource.class.name.downcase.pluralize}\/#{resource.id}" unless resource.blank?
    resource_out = request.env['omniauth.origin'] if resource_out.blank?
    resource_out = root_path if resource_out.blank?
    resource_out
  end
end
