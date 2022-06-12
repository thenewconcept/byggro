module FiltersHelper
  def last_month
    from = (params[:from].presence || Time.now).to_date - 1.month
    to   = (params[:to].presence   || Time.now).to_date - 1.month
    { from: from.beginning_of_month, to: to.end_of_month }
  end

  def next_month
    from = (params[:from].presence || Time.now).to_date + 1.month
    to   = (params[:to].presence   || Time.now).to_date + 1.month
    { from: from.beginning_of_month, to: to.end_of_month }
  end
end
