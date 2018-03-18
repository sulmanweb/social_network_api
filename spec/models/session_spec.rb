require 'rails_helper'

RSpec.describe Session, type: :model do
  it "has a valid factory" do
    session = FactoryBot.build(:session)
    expect(session.valid?).to be_truthy
  end

  it "generates last used at after create" do
    session = FactoryBot.create(:session)
    expect(session.last_used_at).to_not eql nil
  end

  it "must have a uid" do
    session = FactoryBot.build(:session)
    session.valid?
    expect(session.uid).to_not eql nil
  end
end
