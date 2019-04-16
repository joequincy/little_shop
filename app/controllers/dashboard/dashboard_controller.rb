class Dashboard::DashboardController < Dashboard::BaseController
  def index
    @merchant = current_user
    @sales_history = @merchant.sales_history.to_timeseries(:month, :sales)
    @pending_orders = Order.pending_orders_for_merchant(current_user.id)
  end
end
