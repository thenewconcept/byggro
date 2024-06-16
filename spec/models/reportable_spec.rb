require 'rails_helper'
RSpec.describe Reportable, type: :model do
  class DummyList < ActiveRecord::Base
    self.table_name = 'checklists'
    include Reportable
    has_many :reports, as: :reportable, dependent: :destroy
  end

  before do
    @list             = DummyList.create(project_id: create(:project).id)
    contractor_report = create(:report, reportable: @list, reportee: create(:contractor))
    employee_report   = create(:report, reportable: @list, reportee: create(:employee))
    inter_report      = create(:report, reportable: @list, reportee: create(:intern))
    @list.update(reports: [contractor_report, employee_report, inter_report])
  end

  it "should have reports" do
    expect(@list.reports.count).to eq(3)
  end
end
