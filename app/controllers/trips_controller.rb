class TripsController < ApplicationController
  def index
    @trips = []
    begin
      response = Faraday.get(
        'http://127.0.0.1:3000/api/v1/admin/trips',
        {},
        { 'Authorization' => "Bearer #{ENV['ADMIN_SECRET_KEY'] || 'super_secret_admin_key'}" }
      )
      if response.success?
        @trips = JSON.parse(response.body)['trips'] || []
      else
        flash.now[:alert] = "Erreur de l'API (Statut: #{response.status})"
      end
    rescue => e
      flash.now[:alert] = "Impossible de se connecter à l'API."
    end
  end
end
