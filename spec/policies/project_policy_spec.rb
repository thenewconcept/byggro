require 'rails_helper'

RSpec.describe ProjectPolicy, type: :policy do
  let(:user) { User.new(email: 'jane@doe.com', is_admin: true) }

  before do
    5.times { create(:project) }
  end

  subject { described_class }

  permissions ".scope" do
    scope = Project.all
    it "returns everything for a super admin" do
      expect(scope).to be_a(ActiveRecord::Relation)
      expect(scope.count).to eq(5)
    end
  end

  permissions :show? do
    it "grants show to all" do
      expect(subject).to permit(User.new, Project.new)
    end
  end

  permissions :create? do
    it "grants create user is admin" do
      expect(subject).to permit(user, Project.new)
    end
  end

  permissions :update? do
    it "grants update user is admin" do
      expect(subject).to permit(user, Project.new)
    end
  end

  permissions :destroy? do
    it "grants destroy user is admin" do
      expect(subject).to permit(user, Project.new(title: 'Project 1'))
    end
  end
end
