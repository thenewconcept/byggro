class Payroll
  include Pundit::Authorization
  attr_reader :reports

  def initialize(range, current_user=Current.user)
    scope    = ReportPolicy::Scope.new(current_user, Report).resolve
    range    ||= Date.today.beginning_of_month..Date.today.end_of_month

    @reports = scope
      .where(reportable_type: 'Checklist', reportable_id: Checklist.where(bonus: :none).pluck(:id))
      .where.not(reportee_type: ['Contractor', 'Intern'])
      .where(date: range, payable: true)
      .or(
        scope
          .where.not(reportee_type: ['Contractor', 'Intern'])
          .where(payable: true)
          .where(reportable_type: 'Checklist', reportable_id: Checklist
            .joins(:project)
            .where(bonus: :fixed, projects: { status: :completed, completed_on: range })
            .pluck(:id)
          )
      )
  end

  def payments
    reportables.flat_map do |reportable, reports|
      reports.group_by(&:reportee).map do |reportee, reports|
        if reportable.bonus == 'none'
          Hourly.new(reportee, reports)
        elsif reportable.bonus == 'fixed' and reportee.user.is_contractor?
          Hourly.new(reportee, reports)
        elsif reportable.bonus == 'fixed'
          Fixed.new(reportee, reportable)
        end
      end
    end
  end

  def by_type(type)
    payments.select { |payment| payment.reportable.bonus == type.to_s }
  end

  def reportables
    @reports.group_by(&:reportable).uniq
  end

  def projects
    @reports.map(&:project).uniq
  end

  def checklists
    @reports.map(&:reportable).uniq
  end

  def workers
    @reports.map(&:reportee).uniq
  end

  def total
    payments.sum(&:total)
  end
end