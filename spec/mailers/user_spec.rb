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
end
