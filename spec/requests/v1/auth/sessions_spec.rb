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
end