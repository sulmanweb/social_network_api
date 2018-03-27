require 'rails_helper'

RSpec.describe "V1::Comments", type: :request do
  describe "POST /v1/posts/:post_id/comments" do
    let(:post_user) {FactoryBot.create(:post)}
    let(:session) {FactoryBot.create(:session)}
    it "creates a new post in the system" do
      headers = sign_in_test_headers session
      comment_attributes = FactoryBot.attributes_for(:comment)
      post v1_post_comments_path(post_user.id), headers: headers, params: comment_attributes
      expect(response).to have_http_status(201)
      json = JSON.parse(response.body)
      expect(json.length).to eq 5
    end
  end

  describe "PUT /v1/posts/:post_id/comments/id" do
    let(:session) {FactoryBot.create(:session)}
    let(:comment) {FactoryBot.create(:comment, user_id: session.user_id)}
    it "updates a comment for the post in the system" do
      headers = sign_in_test_headers session
      comment_attributes = FactoryBot.attributes_for(:comment, post_id: comment.post_id)
      put v1_post_comment_path(comment.post_id, comment.id), headers: headers, params: comment_attributes
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 5
    end
  end

  describe "DELETE /v1/posts/:post_id/comments/id" do
    let(:session) {FactoryBot.create(:session)}
    let(:comment) {FactoryBot.create(:comment, user_id: session.user_id)}
    it "deletes a comment for the post in the system" do
      headers = sign_in_test_headers session
      delete v1_post_comment_path(comment.post_id, comment.id), headers: headers
      expect(response).to have_http_status(204)
    end
  end

  describe "GET /v1/posts/:post_id/comments" do
    let(:system_post) {FactoryBot.create(:post)}
    before do
      7.times.each do
        FactoryBot.create(:comment, post_id: system_post.id)
      end
    end
    let(:session) {FactoryBot.create(:session)}
    it "gets all comments on the post in system" do
      headers = sign_in_test_headers session
      get v1_post_comments_path(system_post.id, limit: 5), headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 2
      expect(json['page_info']['total_pages']).to eql 2
      expect(json['page_info']['total_records']).to eql 7
    end
  end
end
