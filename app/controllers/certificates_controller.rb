class CertificatesController < ApplicationController
  def list
    finder = CertificateFinder.new(user_id: params[:user_id], event_id: params[:event_id])
    certificates = finder.all
    render json: certificates, status: :ok
  end

  def emit
    finder = CertificateFinder.new(user_id: params[:user_id], event_id: params[:event_id])
    certificates = finder.all
    puts "emit #{params[:uid]}"
  end
end
