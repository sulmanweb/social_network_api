require 'rails_helper'

RSpec.describe UserConfirmation, type: :model do
  it "has a vlid factory" do
    user_confirmation = FactoryBot.build(:user_confirmation)
    expect(user_confirmation.valid?).to be_truthy
  end

  it "gives error if c_type not present" do
    user_confirmation = FactoryBot.build(:user_confirmation, c_type: nil)
    expect(user_confirmation.valid?).to be_falsey
  end

  describe "#status" do
    it {is_expected.to validate_presence_of(:status)}
    it {is_expected.to allow_value(:pending).for(:status)}
    it {is_expected.to allow_value(:approved).for(:status)}
    it {is_expected.to allow_value(:late).for(:status)}
    it {is_expected.to define_enum_for(:status).with([:pending, :approved, :late])}
  end

  describe "#c_type" do
    it {is_expected.to validate_presence_of(:c_type)}
    it {is_expected.to allow_value(:email_confirmation).for(:c_type)}
    it {is_expected.to allow_value(:reset_password).for(:c_type)}
    it {is_expected.to define_enum_for(:c_type).with([:email_confirmation, :reset_password])}
  end
end
