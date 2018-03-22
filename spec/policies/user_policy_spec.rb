require 'rails_helper'

RSpec.describe UserPolicy do

  let(:u1) {FactoryBot.create(:user)}
  let(:u2) {FactoryBot.create(:user)}

  subject {described_class}

  permissions :request_friend? do
    it "allows if user is requesting for particular user for first time" do
      expect(subject).to permit(u1, u2)
    end
    it "denies if user and requester is same" do
      expect(subject).to_not permit(u1, u1)
    end
    it "denies if user has already have friend request" do
      u1.friend_request u2
      expect(subject).to_not permit(u1, u2)
      expect(subject).to_not permit(u2, u2)
    end
    it "denies if user has already have that friend" do
      u1.friend_request u2
      u2.accept_request u1
      expect(subject).to_not permit(u1, u2)
      expect(subject).to_not permit(u2, u2)
    end
  end

  permissions :accept_friend? do
    it "allows if user is not requester and user has friend request friend" do
      u1.friend_request u2
      expect(subject).to permit(u2, u1)
    end
    it "denies if user has not requested to accept friend" do
      expect(subject).to_not permit(u2, u1)
    end
  end
end
