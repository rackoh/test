class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

	def record_not_found
	  render :json => {:status => 400, :error => "Records Not Found"}
	end
end
