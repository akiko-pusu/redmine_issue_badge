require_relative '../spec_helper'

describe IssueBadgeUserSetting do
  context "instantiation" do
    before do
      @user = create(:user)
    end

    it 'instantiates a usersetting for badge' do
      setting = IssueBadgeUserSetting.find_or_create_by_user_id(@user.id)
      expect(setting.class.name).to eq("IssueBadgeUserSetting")
    end

    it 'usersetting for badge enable is null before save' do
      setting = IssueBadgeUserSetting.find_or_create_by_user_id(@user.id)
      puts "user_id #{setting.user_id}"
      puts "user.is #{@user.id}"
      expect(setting.enabled).to be_nil
      expect(setting.user_id).to eq(@user.id)
    end

    it 'usersetting for badge enable is after save with enabled' do
      setting = IssueBadgeUserSetting.find_or_create_by_user_id(@user.id)
      setting.enabled = true
      expect(setting.save).to be_truthy
      expect(setting.enabled).to be_truthy
      expect(setting.enabled?).to be_truthy
    end

    it 'usersetting for badge enable is after save with enabled' do
      setting = IssueBadgeUserSetting.find_or_create_by_user_id(@user.id)
      setting.enabled = false
      expect(setting.save).to be_truthy
      expect(setting.enabled).not_to be_truthy
      expect(setting.enabled?).to be_falsey
    end
  end

  context "destroy" do
    before do
      @user = create(:user)
    end
    it "usersetting for badge is null after destroy" do
      setting = IssueBadgeUserSetting.find_or_create_by_user_id(@user.id)
      expect(setting.save).to be_truthy

      IssueBadgeUserSetting.destroy_by_user_id(@user.id)
      result = IssueBadgeUserSetting.where("user_id = ?", @user.id)
      expect(result.empty?).to be_truthy
    end
  end
end
