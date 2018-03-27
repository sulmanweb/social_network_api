require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "has valid factory" do
    comment = FactoryBot.build(:comment)
    expect(comment.valid?).to be_truthy
  end

  it "must contain user and post" do
    comment = FactoryBot.build(:comment, user_id: nil)
    expect(comment.valid?).to be_falsey
    comment = FactoryBot.build(:comment, post_id: nil)
    expect(comment.valid?).to be_falsey
  end

  it "must contain body" do
    comment = FactoryBot.build(:comment, body: nil)
    expect(comment.valid?).to be_falsey
  end
end
