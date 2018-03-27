require "rails_helper"

RSpec.describe FriendshipsMailer, type: :mailer do
  describe "requested" do
    let(:user1) {FactoryBot.create(:user)}
    let(:user2) {FactoryBot.create(:user)}
    let(:mail) {FriendshipsMailer.requested(user1.id, user2.id)}

    it "sends friend request mail" do
      expect(mail.to).to eql [user1.email]
    end

    it "send friend request default mailer" do
      expect(mail.from).to eql [DEFAULT_MAILER]
    end
  end

  describe "accepted" do
    let(:user1) {FactoryBot.create(:user)}
    let(:user2) {FactoryBot.create(:user)}
    let(:mail) {FriendshipsMailer.accepted(user1.id, user2.id)}

    it "sends accepted friend request mail" do
      expect(mail.to).to eql [user1.email]
    end

    it "sends accepted friend request mail from default mailer" do
      expect(mail.from).to eql [DEFAULT_MAILER]
    end
  end
end
