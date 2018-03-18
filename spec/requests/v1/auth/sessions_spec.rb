require 'rails_helper'

RSpec.describe "V1::Auth::Sessions", type: :request do
  describe "POST /v1/auth/sign_in" do
    it "creates a new token for user in system" do
      user = FactoryBot.create(:user)
      post v1_auth_sign_in_path, params: {auth: user.username, password: user.password}
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq 1
      post v1_auth_sign_in_path, params: {auth: user.email, password: user.password}
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq 1
      current_user = User.find_by_id(JsonWebToken.decode(json['token'])[:user_id])
      expect(current_user.nil?).to be_falsey
    end

    it "gives 401 if invalid credentials provided" do
      user = FactoryBot.create(:user)
      post v1_auth_sign_in_path, params: {auth: user.username, password: 'abcd'}
      expect(response).to have_http_status(401)
      json = JSON.parse(response.body)
      expect(json.length).to eq 1
      post v1_auth_sign_in_path, params: {auth: user.username + "ab", password: user.password}
      expect(response).to have_http_status(401)
      json = JSON.parse(response.body)
      expect(json.length).to eq 1
    end
  end

  describe "DELETE v1/auth/sign_out" do
    let(:session) {FactoryBot.create(:session)}
    it "destroys user session" do
      headers = sign_in_test_headers session
      delete v1_auth_sign_out_path, headers: headers
      expect(response).to have_http_status(204)
    end
    it "gives error if user not signed in" do
      delete v1_auth_sign_out_path
      expect(response).to have_http_status(401)
    end
    it "gives error if wrong tokens" do
      session = FactoryBot.create(:session)
      session.uid = 'aaaaaaaaaaaaaaaaaaaaa'
      headers = sign_in_test_headers session
      delete v1_auth_sign_out_path, headers: headers
      expect(response).to have_http_status(401)
    end
  end
end