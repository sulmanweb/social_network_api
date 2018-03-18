require 'rails_helper'

RSpec.describe "V1::Auth::Passwords", type: :request do
  describe "POST /v1/auth/reset_password" do
    let(:user) {FactoryBot.create(:user)}
    it "creates request to reset password" do
      post v1_auth_reset_password_path, params: {email: user.email}
      expect(response).to have_http_status(201)
    end
    it "gives error if email not provided" do
      post v1_auth_reset_password_path
      expect(response).to have_http_status(422)
    end
    it "doesnot give error if incorrect email" do
      post v1_auth_reset_password_path, params: {email: 'bwjhvbwejrhvbjwbv'}
      expect(response).to have_http_status(201)
    end
  end

  describe "GET /v1/auth/update_reset" do
    let(:confirmation) {FactoryBot.create(:user_confirmation, c_type: 'reset_password')}
    it "update request to reset password" do
      get v1_auth_update_reset_path, params: {token: confirmation.token}
      expect(response).to have_http_status(302)
    end
    it "gives error if token not provided" do
      get v1_auth_update_reset_path
      expect(response).to have_http_status(422)
    end
    it "does give error if incorrect token " do
      get v1_auth_update_reset_path, params: {token: 'bwjhvbwejrhvbjwbv'}
      expect(response).to have_http_status(401)
    end
  end

  describe "PUT /v1/auth/change_password" do
    let(:session) {FactoryBot.create(:session)}
    it "change user password" do
      headers = sign_in_test_headers session
      put v1_auth_change_password_path, headers: headers, params: {password: "Abcd@1234", password_confirmation: "Abcd@1234"}
      expect(response).to have_http_status(200)
    end
    it "gives error if user not logged in" do
      put v1_auth_change_password_path, params: {password: "Abcd@1234", password_confirmation: "Abcd@1234"}
      expect(response).to have_http_status(401)
    end
    it "gives error if password does not satisfy regex" do
      headers = sign_in_test_headers session
      put v1_auth_change_password_path, headers: headers, params: {password: "Abcd1234", password_confirmation: "Abcd1234"}
      expect(response).to have_http_status(422)
    end
  end
end
