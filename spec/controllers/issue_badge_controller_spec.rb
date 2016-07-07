require_relative '../spec_helper'

describe IssueBadgeController do
  #
  # TODO: Change not to use Redmine's fixture but to use Factory...
  #
  fixtures :projects,
           :users, :email_addresses,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :trackers,
           :projects_trackers,
           :issue_categories,
           :enabled_modules,
           :enumerations,
           :workflows,
           :custom_fields,
           :custom_values,
           :custom_fields_projects,
           :custom_fields_trackers

  describe 'GET #index' do
    before(:each) do
      #
      # Logged in as Dave
      #
      @request.session[:user_id] = 3
    end

    it 'renders the _issue_badge template' do
      get :index
      expect(assigns(:all_issues_count)).not_to be_nil
      expect(response).to render_template(partial: '_issue_badge')
    end
  end

  describe 'GET #load_badge_contents' do
    before(:each) do
      @request.session[:user_id] = 3
    end

    it 'renders the _issue_badge_contents template' do
      get :load_badge_contents
      expect(assigns(:limited_issues)).not_to be_nil
      expect(response).to render_template(partial: '_issue_badge_contents')
    end
  end
end
