# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../rails_helper'

describe IssueBadgeUserSetting do
  let(:user) { create(:user) }
  let(:setting) { described_class.find_or_create_by_user_id(user) }

  describe '.find_or_create_by_user_id' do
    it 'instantiates a usersetting for badge' do
      expect(setting.class.name).to eq('IssueBadgeUserSetting')
    end

    it 'usersetting for badge enable is null before save' do
      expect(setting.enabled).to be_nil
      expect(setting.user_id).to eq(user.id)
    end

    it 'usersetting for badge enable is after save with enabled' do
      setting.enabled = true
      expect(setting.save).to be_truthy
      expect(setting.enabled).to be_truthy
      expect(setting.enabled?).to be_truthy
    end

    it 'usersetting for badge enable is after save with enabled' do
      setting.enabled = false
      expect(setting.save).to be_truthy
      expect(setting.enabled).not_to be_truthy
      expect(setting.enabled?).to be_falsey
    end
  end

  describe '.destroy' do
    it 'usersetting for badge is null after destroy' do
      IssueBadgeUserSetting.destroy_by_user_id(user)
      result = IssueBadgeUserSetting.where('user_id = ?', user.id)
      expect(result.empty?).to be_truthy
    end
  end

  describe '#validate_query_id' do
    subject { setting.save }
    before do
      expect(setting).to receive(:validate_query_id).and_call_original
    end

    context 'when non-exists query_id is specified' do
      let(:query_id) { 5000 }
      it 'instance query_id is nil' do
        setting.query_id = query_id
        subject
        expect(setting.reload.query_id).to be_nil
      end
    end

    context 'when exists query_id is specified' do
      let(:query_id) { IssueQuery.first.id }
      before do
        query = IssueQuery.new(project: nil, name: '_')
        query.visibility = IssueQuery::VISIBILITY_PUBLIC
        query.add_filter('assigned_to_id', '!*', [''])
        query.save
      end

      it 'instance query_id is not nil' do
        setting.query_id = query_id
        subject
        expect(setting.reload.query_id).to eq(query_id)
      end
    end
  end
end
