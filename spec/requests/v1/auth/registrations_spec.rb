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

  describe "DELETE /v1/auth/destroy" do
    let(:session) {FactoryBot.create(:session)}
    it "destroys the user from the system" do
      headers = sign_in_test_headers session
      delete v1_auth_destroy_path, headers: headers
      expect(response).to have_http_status(204)
      expect(User.find_by_id(session.user_id)).to eql nil
    end
    it "gives error if user not signed in" do
      delete v1_auth_destroy_path
      expect(response).to have_http_status(401)
    end
    it "gives error if wrong tokens" do
      session = FactoryBot.create(:session)
      session.uid = 'aaaaaaaaaaaaaaaaaaaaa'
      headers = sign_in_test_headers session
      delete v1_auth_destroy_path, headers: headers
      expect(response).to have_http_status(401)
    end
  end
end
