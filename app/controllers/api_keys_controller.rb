class ApiKeysController < ApplicationController
  include ApiKeyAuthenticatable

  # Require API key authentication
  prepend_before_action :authenticate_with_api_key!, only: %i[index destroy]

  def index
    render json: current_bearer.api_keys
  end

  def create
    authenticate_with_http_basic do |email, password|
      user = User.find_by email: email

      if user&.authenticate(password)
        api_key = user.api_keys.create! token: SecureRandom.hex

        render json: api_key, status: :created and return
      end
    end

    render status: :unauthorized
  end

  def destroy
    api_key = current_bearer.api_keys.find(params[:id])

    api_key.destroy
  end
end