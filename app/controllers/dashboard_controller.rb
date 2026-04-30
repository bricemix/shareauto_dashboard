class DashboardController < ApplicationController
  def index
    @stats = { 'active_users' => 0, 'today_trips' => 0, 'monthly_revenue' => 0, 'pending_partners' => 0 }
    @recent_trips = []
    
    begin
      response = Faraday.get(
        'http://127.0.0.1:3000/api/v1/admin/dashboard',
        {},
        { 'Authorization' => "Bearer #{ENV['ADMIN_SECRET_KEY'] || 'super_secret_admin_key'}" }
      )
      
      if response.success?
        data = JSON.parse(response.body)
        @stats = data['stats'] || @stats
        @recent_trips = data['recent_trips'] || []
        @api_error = false
      else
        @api_error = true
      end
    rescue => e
      @api_error = true
    end
  end
end
