class VerificationsController < ApplicationController
  def index
    @verifications = []
    begin
      response = Faraday.get(
        'http://127.0.0.1:3000/api/v1/admin/verifications',
        {},
        { 'Authorization' => "Bearer #{ENV['ADMIN_SECRET_KEY'] || 'super_secret_admin_key'}" }
      )
      if response.success?
        @verifications = JSON.parse(response.body)['verifications'] || []
      else
        flash.now[:alert] = "Erreur de l'API (Statut: #{response.status})"
      end
    rescue => e
      flash.now[:alert] = "Impossible de se connecter à l'API."
    end
  end

  def approve
    make_api_call(:approve)
  end

  def reject
    make_api_call(:reject)
  end

  private

  def make_api_call(action)
    begin
      response = Faraday.patch(
        "http://127.0.0.1:3000/api/v1/admin/verifications/#{params[:id]}/#{action}",
        {},
        { 'Authorization' => "Bearer #{ENV['ADMIN_SECRET_KEY'] || 'super_secret_admin_key'}" }
      )
      if response.success?
        flash[:notice] = "Document #{action == :approve ? 'approuvé' : 'rejeté'} avec succès."
      else
        flash[:alert] = "Erreur lors de l'opération."
      end
    rescue => e
      flash[:alert] = "Impossible de se connecter à l'API."
    end
    redirect_to verifications_path
  end
end
