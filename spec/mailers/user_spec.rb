require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "confirmation" do
    let(:user_confirmation) {FactoryBot.create(:user_confirmation)}
    let(:mail) {UserMailer.confirmation(user_confirmation.user.id, user_confirmation.id)}

    it "sends confirmation email to the user's email address" do
      expect(mail.to).to eql [user_confirmation.user.email]
    end

    it "send welcome email from default mailer" do
      expect(mail.from).to eql [DEFAULT_MAILER]
    end
  end

  describe "reset_password" do
    let(:user_confirmation) {FactoryBot.create(:user_confirmation, c_type: "reset_password")}
    let(:mail) {UserMailer.confirmation(user_confirmation.user.id, user_confirmation.id)}

    it "sends reset password email to the user's email address" do
      expect(mail.to).to eql [user_confirmation.user.email]
    end

    it "send reset_password email from default mailer" do
      expect(mail.from).to eql [DEFAULT_MAILER]
    end
  end
end
