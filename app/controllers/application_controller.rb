class ApplicationController < ActionController::Base
  include Controllers::Base, ApplicationHelper

  protect_from_forgery with: :exception, prepend: true
end
