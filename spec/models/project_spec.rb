require 'rails_helper'

RSpec.describe Project, type: :model do

  before do
    @project = Project.create!(
      title: "Askims 12", 
      adress: "Askims Kyrkåsväg 12",
      description: "En beskrivning av projektet.",
      material_amount: 32000, 
      misc_amount: 500, 
    )
    @project.checklists.create!(title: 'Work', amount: 134700)
  end

  it 'proper calculations' do
    expect(@project.total).to eq(167200)
    expect(@project.client_costs).to eq(169000)
    expect(@project.client_costs).to eq(169000)
    expect(@project.client_payed).to eq(118487.5)
    expect(@project.rot).to eq(50512.5)
  end

end
