class Admin::ReportsController < Admin::BaseController
  def index
    @orders = Order.by_date(from_date, to_date)
  end

  private

  def from_date
    params[:from_date]&.to_date || 5.days.ago.to_date
  end

  def to_date
    params[:to_date]&.to_date || Date.today
  end

end
