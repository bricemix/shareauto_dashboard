class UsersController < ApplicationController
  def index
    @users = []
    begin
      response = Faraday.get(
        'http://127.0.0.1:3000/api/v1/admin/users',
        {},
        { 'Authorization' => "Bearer #{ENV['ADMIN_SECRET_KEY'] || 'super_secret_admin_key'}" }
      )
      if response.success?
        @users = JSON.parse(response.body)['users'] || []
      else
        flash.now[:alert] = "Erreur de l'API (Statut: #{response.status})"
      end
    rescue => e
      flash.now[:alert] = "Impossible de se connecter à l'API."
    end
  end
end
