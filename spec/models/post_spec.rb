require 'rails_helper'

RSpec.describe Post, type: :model do
  it "has a valid factory" do
    post = FactoryBot.build(:post)
    expect(post.valid?).to be_truthy
  end

  it "cannot exist without a user or text" do
    post = FactoryBot.build(:post, user_id: nil)
    expect(post.valid?).to be_falsey
    post = FactoryBot.build(:post, body: nil)
    expect(post.valid?).to be_falsey
  end
end
