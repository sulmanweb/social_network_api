require 'rails_helper'

RSpec.describe "V1::Users", type: :request do
  describe "GET /v1/users" do
    let(:session) {FactoryBot.create(:session)}
    before do
      7.times.each do
        FactoryBot.create(:user)
      end
    end
    it "shows user list" do
      get v1_users_path, params: {limit: 5}
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 2
      expect(json['page_info']['total_pages']).to eql 2
      expect(json['page_info']['total_records']).to eql 7
      expect(json['users'][0].length).to eql 4
    end
    it "gives one less user on signed in" do
      user = User.last
      session = user.sessions.create
      headers = sign_in_test_headers session
      get v1_users_path, headers: headers, params: {limit: 5}
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 2
      expect(json['page_info']['total_pages']).to eql 2
      expect(json['page_info']['total_records']).to eql 6
      expect(json['users'][0].length).to eql 6
    end
  end

  describe "PUT /v1/users/:id/request_friend" do
    before do
      2.times.each do
        FactoryBot.create(:user)
      end
    end
    let(:u1_session) {User.last.sessions.create}
    it "creates a friend request" do
      headers = sign_in_test_headers u1_session
      put request_friend_v1_user_path(id: User.first.id), headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 1
    end
    it "deenies if double request sent" do
      headers = sign_in_test_headers u1_session
      put request_friend_v1_user_path(id: User.first.id), headers: headers
      put request_friend_v1_user_path(id: User.first.id), headers: headers
      expect(response).to have_http_status(403)
    end
  end

  describe "PUT /v1/users/:id/accept_friend" do
    before do
      2.times.each do
        FactoryBot.create(:user)
      end
    end
    let(:u1_session) {User.last.sessions.create}
    it "accepts a friend request" do
      User.first.friend_request User.last
      headers = sign_in_test_headers u1_session
      put accept_friend_v1_user_path(id: User.first.id), headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 1
    end
    it "denies if double request sent" do
      User.first.friend_request User.last
      headers = sign_in_test_headers u1_session
      put request_friend_v1_user_path(id: User.first.id), headers: headers
      put request_friend_v1_user_path(id: User.first.id), headers: headers
      expect(response).to have_http_status(403)
    end
    it "doest accept friendship if not requested" do
      headers = sign_in_test_headers u1_session
      put accept_friend_v1_user_path(id: User.first.id), headers: headers
      expect(response).to have_http_status(403)
      json = JSON.parse(response.body)
      expect(json.length).to eq 1
    end
  end

  describe "GET /v1/users/friends" do
    before do
      2.times.each do
        FactoryBot.create(:user)
      end
      User.first.friend_request User.last
    end
    let(:u1_session) {User.first.sessions.create}
    it "shows zero count if no friend" do
      headers = sign_in_test_headers u1_session
      get friends_v1_users_path, headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 2
      expect(json['page_info']['total_pages']).to eql 0
      expect(json['page_info']['total_records']).to eql 0
    end
    it "shows the friend list" do
      User.last.accept_request User.first
      headers = sign_in_test_headers u1_session
      get friends_v1_users_path, headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 2
      expect(json['page_info']['total_pages']).to eql 1
      expect(json['page_info']['total_records']).to eql 1
    end
  end

  describe "GET /v1/users/requested_friends" do
    before do
      2.times.each do
        FactoryBot.create(:user)
      end
    end
    let(:u1_session) {User.first.sessions.create}
    it "shows zero count if no friend" do
      headers = sign_in_test_headers u1_session
      get requested_friends_v1_users_path, headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 2
      expect(json['page_info']['total_pages']).to eql 0
      expect(json['page_info']['total_records']).to eql 0
    end
    it "shows the requested friend list" do
      User.last.friend_request User.first
      headers = sign_in_test_headers u1_session
      get requested_friends_v1_users_path, headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 2
      expect(json['page_info']['total_pages']).to eql 1
      expect(json['page_info']['total_records']).to eql 1
    end
  end

  describe "GET /v1/users/pending_friends" do
    before do
      2.times.each do
        FactoryBot.create(:user)
      end
    end
    let(:u1_session) {User.first.sessions.create}
    it "shows zero count if no friend" do
      headers = sign_in_test_headers u1_session
      get pending_friends_v1_users_path, headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 2
      expect(json['page_info']['total_pages']).to eql 0
      expect(json['page_info']['total_records']).to eql 0
    end
    it "shows the requested friend list" do
      User.first.friend_request User.last
      headers = sign_in_test_headers u1_session
      get pending_friends_v1_users_path, headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 2
      expect(json['page_info']['total_pages']).to eql 1
      expect(json['page_info']['total_records']).to eql 1
    end
  end
end
