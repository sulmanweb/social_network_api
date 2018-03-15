require 'rails_helper'

RSpec.describe "V1::Auth::Registrations", type: :request do
  describe "POST /v1/auth/sign_up" do
    it "creates a new user in system" do
      signup_attributes = FactoryBot.attributes_for(:user)
      post v1_auth_sign_up_path, params: signup_attributes
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq 5
    end
    it "gives 422 if data incorrect" do
      signup_attributes = FactoryBot.attributes_for(:user, password: "")
      post v1_auth_sign_up_path, params: signup_attributes
      expect(response).to have_http_status(422)
    end
    it "gives 422 if data incomplete" do
      signup_attributes = FactoryBot.attributes_for(:user, password: nil)
      post v1_auth_sign_up_path, params: signup_attributes
      expect(response).to have_http_status(422)
    end
    it "gives 422 on duplication" do
      FactoryBot.create(:user, username: "sulmanweb")
      signup_attributes = FactoryBot.attributes_for(:user, username: "sulmanweb")
      post v1_auth_sign_up_path, params: signup_attributes
      expect(response).to have_http_status(422)
    end
  end
end
