require 'rails_helper'

RSpec.describe "V1::Auth::Registrations", type: :request do
  describe "GET /v1/auth/confirm_email" do
    let(:user) {FactoryBot.create(:user)}
    it "confirms the new user in system" do
      get v1_auth_confirm_email_path, params: {token: user.user_confirmations.last.token}
      expect(response).to have_http_status(302)
      expect(response).to redirect_to EMAIL_CONFIRMATION_SITE
    end
    it "gives error if token not provided" do
      get v1_auth_confirm_email_path
      expect(response).to have_http_status(422)
    end
    it "gives error if token is incorrect" do
      get v1_auth_confirm_email_path, params: {token: "aaaaaaaa"}
      expect(response).to have_http_status(401)
    end
  end
end
