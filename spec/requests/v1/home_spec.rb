require 'rails_helper'

RSpec.describe "V1::Home", type: :request do
  describe "GET /v1/home" do
    let(:session1) {FactoryBot.create(:session)}
    let(:session2) {FactoryBot.create(:session)}
    let(:session3) {FactoryBot.create(:session)}
    before do
      7.times do
        FactoryBot.create(:post, user_id: session1.user_id)
      end
      7.times do
        FactoryBot.create(:post, user_id: session2.user_id)
      end
      7.times do
        FactoryBot.create(:post, user_id: session3.user_id)
      end
    end
    it "shows posts of own and friends" do
      session1.user.friend_request session2.user
      session2.user.accept_request session1.user
      headers = sign_in_test_headers session1
      get v1_home_path(limit: 5), headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 2
      expect(json['page_info']['total_pages']).to eql 3
      expect(json['page_info']['total_records']).to eql 14
    end
    it "shows only own if no friends" do
      headers = sign_in_test_headers session1
      get v1_home_path(limit: 5), headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 2
      expect(json['page_info']['total_pages']).to eql 2
      expect(json['page_info']['total_records']).to eql 7
    end
  end
end