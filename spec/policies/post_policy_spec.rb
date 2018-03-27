require 'rails_helper'

RSpec.describe PostPolicy do

  let(:post) {FactoryBot.create(:post)}

  subject {described_class}

  permissions :update? do
    it "denies if user is not the author of the post" do
      expect(subject).to_not permit(FactoryBot.build(:user), post)
    end
    it "allows if user is the author of the post" do
      expect(subject).to permit(post.user, post)
    end
  end

  permissions :destroy? do
    it "denies if user is not the author of the post" do
      expect(subject).to_not permit(FactoryBot.build(:user), post)
    end
    it "allows if user is the author of the post" do
      expect(subject).to permit(post.user, post)
    end
  end
end
