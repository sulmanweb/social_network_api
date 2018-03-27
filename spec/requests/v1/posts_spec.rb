require 'rails_helper'

RSpec.describe "V1::Posts", type: :request do
  describe "POST /v1/posts" do
    let(:session) {FactoryBot.create(:session)}
    it "creates a new post in the system" do
      headers = sign_in_test_headers session
      post_attributes = FactoryBot.attributes_for(:post, user_id: session.user_id)
      post v1_posts_path, headers: headers, params: post_attributes
      expect(response).to have_http_status(201)
      json = JSON.parse(response.body)
      expect(json.length).to eq 4
    end
    it "gives error if body empty" do
      headers = sign_in_test_headers session
      post_attributes = FactoryBot.attributes_for(:post, user_id: session.user_id, body: nil)
      post v1_posts_path, headers: headers, params: post_attributes
      expect(response).to have_http_status(422)
    end
    it "gives error if user not signed in" do
      post_attributes = FactoryBot.attributes_for(:post, user_id: nil)
      post v1_posts_path, params: post_attributes
      expect(response).to have_http_status(401)
    end
  end

  describe "PUT /v1/posts/:id" do
    let(:session) {FactoryBot.create(:session)}
    let(:post) {FactoryBot.create(:post, user: session.user)}
    it "updates the post" do
      headers = sign_in_test_headers session
      post_attributes = FactoryBot.attributes_for(:post, body: "fewfewfewf")
      put v1_post_path(post), headers: headers, params: post_attributes
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 4
    end
    it "rejects if user is not post owner" do
      s = FactoryBot.create(:session)
      headers = sign_in_test_headers s
      post_attributes = FactoryBot.attributes_for(:post, body: "fewfewfewf", user_id: s.user_id)
      put v1_post_path(post), headers: headers, params: post_attributes
      expect(response).to have_http_status(403)
    end
  end

  describe "DELETE /v1/posts/:id" do
    let(:session) {FactoryBot.create(:session)}
    let(:post) {FactoryBot.create(:post, user: session.user)}
    it "deletes the post" do
      headers = sign_in_test_headers session
      delete v1_post_path(post), headers: headers
      expect(response).to have_http_status(204)
    end
    it "rejects if user is not post owner" do
      s = FactoryBot.create(:session)
      headers = sign_in_test_headers s
      delete v1_post_path(post), headers: headers
      expect(response).to have_http_status(403)
    end
  end

  describe "GET /v1/:user_id/posts" do
    let(:user) {FactoryBot.create(:user)}
    before do
      7.times.each do
        FactoryBot.create(:post, user_id: user.id)
      end
    end
    it "Shows user posts" do
      get v1_user_posts_path(limit: 5, user_id: user.id)
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 2
      expect(json['page_info']['total_pages']).to eql 2
      expect(json['page_info']['total_records']).to eql 7
    end
    it "gives zero records if user has no posts" do
      user = FactoryBot.create(:user)
      get v1_user_posts_path(limit: 5, user_id: user.id)
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 2
      expect(json['page_info']['total_pages']).to eql 0
      expect(json['page_info']['total_records']).to eql 0
    end
  end
end
