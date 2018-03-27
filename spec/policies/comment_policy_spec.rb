require 'rails_helper'

RSpec.describe CommentPolicy do

  let(:comment) {FactoryBot.create(:comment)}

  subject {described_class}

  permissions :update? do
    it "denies if user is not the author of the comment" do
      expect(subject).to_not permit(FactoryBot.build(:user), comment)
    end
    it "allows if user is the author of the comment" do
      expect(subject).to permit(comment.user, comment)
    end
  end

  permissions :destroy? do
    it "denies if user is not the author of the comment" do
      expect(subject).to_not permit(FactoryBot.build(:user), comment)
    end
    it "allows if user is the author of the comment" do
      expect(subject).to permit(comment.user, comment)
    end
  end
end
