module Authenticable
  extend ActiveSupport::Concern
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  def authenticate_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @token = decode(header)
      @current_user = User.find(@token['uid'])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def attempt_to_authenticate_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @token = decode(header)
      @current_user = User.find(@token['uid'])
    rescue; end
  end

  def encode(payload, exp = 7.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def decode(token)
    JWT.decode(token, SECRET_KEY).first
  end
end
