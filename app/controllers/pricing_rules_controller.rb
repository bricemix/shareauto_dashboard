class PricingRulesController < ApplicationController
  def edit
    @pricing_rule = fetch_pricing_rule
  end

  def update
    begin
      response = Faraday.patch(
        'http://127.0.0.1:3000/api/v1/admin/pricing_rule',
        { pricing_rule: pricing_rule_params }.to_json,
        { 
          'Authorization' => "Bearer #{ENV['ADMIN_SECRET_KEY'] || 'super_secret_admin_key'}",
          'Content-Type' => 'application/json'
        }
      )
      if response.success?
        flash[:notice] = "Configuration tarifaire mise à jour avec succès."
      else
        flash[:alert] = "Erreur lors de la mise à jour."
      end
    rescue => e
      flash[:alert] = "Impossible de se connecter à l'API."
    end
    redirect_to edit_pricing_rule_path
  end

  private

  def fetch_pricing_rule
    begin
      response = Faraday.get(
        'http://127.0.0.1:3000/api/v1/admin/pricing_rule',
        {},
        { 'Authorization' => "Bearer #{ENV['ADMIN_SECRET_KEY'] || 'super_secret_admin_key'}" }
      )
      if response.success?
        JSON.parse(response.body)['pricing_rule'] || default_rule
      else
        default_rule
      end
    rescue
      default_rule
    end
  end

  def default_rule
    { 'base_price' => 2.0, 'price_per_km' => 1.5, 'price_per_passenger' => 0.5, 'price_per_kg_luggage' => 0.2 }
  end

  def pricing_rule_params
    params.require(:pricing_rule).permit(:base_price, :price_per_km, :price_per_passenger, :price_per_kg_luggage)
  end
end
