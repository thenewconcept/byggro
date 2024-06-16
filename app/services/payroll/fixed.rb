class Payroll::Fixed
  attr_reader :reportee, :reportable

  def initialize(reportee, reportable)
    @reportee = reportee
    @reportable = reportable
  end

  def time_in_hours
    @reportable.reports.where(reportee: @reportee).sum(&:time_in_hours)
  end

  def total
    calculated_bonus
  end

  private

  def calculated_bonus
    total_hours_by_employees    = @reportable.reports.where.not(reportee_type: ['Contractor', 'Intern']).sum(&:time_in_hours)
    total_amount_by_contractors = @reportable.reports.where(reportee_type: ['Contractor']).sum(&:total) 
    total_payable_amount = (@reportable.amount - total_amount_by_contractors) * @reportable.fixed_fee
    total_for_worker = total_payable_amount * (time_in_hours / total_hours_by_employees)
  end
end