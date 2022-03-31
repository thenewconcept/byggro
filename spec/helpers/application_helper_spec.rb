require 'rails_helper'

RSpec.describe ApplicationHelper do
  it '.formatted_time' do
    expect(helper.format_hours(1.5)).to eq('1:30')
    expect(helper.format_hours(2.25)).to eq('2:15')
    expect(helper.format_hours(1.22)).to eq('1:13')
    expect(helper.format_hours(0.17)).to eq('0:10')
    expect(helper.format_hours(28.32)).to eq('28:19')
  end
end