require_relative '../spec_helper'

describe IssueBadgeController do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:tracker) do
    FactoryGirl.create(:tracker, :with_default_status)
  end
  let(:role) { FactoryGirl.create(:role) }
  let(:issue_priority) { FactoryGirl.create(:priority) }
  let(:issues) do
    FactoryGirl.create_list(:issue, issue_count, tracker_id: tracker.id, priority_id: issue_priority.id)
  end

  describe 'GET #index' do
    before(:each) do
      project.trackers << tracker
      member = Member.new(project: project, user_id: user.id)
      member.member_roles << MemberRole.new(role: role)
      @request.session[:user_id] = user.id
    end

    render_views
    context 'When assigned no issue.' do
      it 'renders the _issue_badge template' do
        get :index
        expect(assigns(:all_issues_count)).not_to be_nil
        expect(response).to render_template(partial: '_issue_badge')
        expect(response.body).to match(/<span id="issue_badge_number" class="badge">0/im)
      end
    end

    context 'When assigned some issues' do
      let(:issue_count) { 4 }
      before do
        issues.each do |i|
          i.assigned_to_id = user.id
          i.save
        end
      end
      it 'renders the _issue_badge template' do
        get :index
        expect(assigns(:all_issues_count)).not_to be_nil
        expect(response).to render_template(partial: '_issue_badge')
        expect(response.body).to match(/<span id="issue_badge_number" class="badge">#{issue_count}/im)
      end
    end
  end

  describe 'GET #load_badge_contents' do
    before(:each) do
      @request.session[:user_id] = user.id
    end

    it 'renders the _issue_badge_contents template' do
      get :load_badge_contents
      expect(assigns(:limited_issues)).not_to be_nil
      expect(response).to render_template(partial: '_issue_badge_contents')
    end
  end
end
