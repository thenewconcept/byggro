require 'rails_helper'

RSpec.describe ApplicationHelper do
  it '.formatted_time' do
    expect(helper.format_hours(1.5)).to eq('01:30')
    expect(helper.format_hours(2.25)).to eq('02:15')
    expect(helper.format_hours(1.22)).to eq('01:13')
    expect(helper.format_hours(0.17)).to eq('00:10')
    expect(helper.format_hours(28.32)).to eq('28:19')
  end
end