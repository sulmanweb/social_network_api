require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    user = FactoryBot.build(:user)
    expect(user.valid?).to be_truthy
  end

  it "check the email and username uniqueness" do
    user = FactoryBot.create(:user)
    u1 = FactoryBot.build(:user, email: user.email)
    expect(u1.valid?).to be_falsey
    u2 = FactoryBot.build(:user, username: user.username)
    expect(u2.valid?).to be_falsey
  end

  it "must check email format" do
    user = FactoryBot.build(:user, email: "sulmanweb@gmail@com")
    expect(user.valid?).to be_falsey
    user.email = "sulmanweb"
    expect(user.valid?).to be_falsey
    user.email = "sulmanweb@gmail"
    expect(user.valid?).to be_falsey
    user.email = "sulmanweb@gmail.com"
    expect(user.valid?).to be_truthy
  end

  it "must check username format" do
    user = FactoryBot.build(:user, username: '')
    expect(user.valid?).to be_falsey
    user.username = "sulman web"
    expect(user.valid?).to be_falsey
    user.username = "sulman@web"
    expect(user.valid?).to be_falsey
    user.username = "sulmanweb12"
    expect(user.valid?).to be_truthy
  end

  it "must check password format" do
    user = FactoryBot.build(:user, password: "abcdefg", password_confirmation: "abcdefg")
    expect(user.valid?).to be_falsey
    user.password = "abcdefghi2"
    user.password_confirmation = "abcdefghi2"
    expect(user.valid?).to be_falsey
    user.password = "Abcd@1234"
    user.password_confirmation = "Abcd@1234"
    expect(user.valid?).to be_truthy
  end

  it "must contain password while creating" do
    user = FactoryBot.build(:user, password: "", password_confirmation: "")
    expect(user.valid?).to be_falsey
  end

  it "can update without password" do
    user = FactoryBot.create(:user)
    expect(user.update(name: "Sulman")).to be_truthy
  end

  it "must contain password confirmation" do
    user = FactoryBot.build(:user, password_confirmation: nil)
    expect(user.valid?).to be_falsey
  end
end
