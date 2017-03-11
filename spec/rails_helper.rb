# frozen_string_literal: true
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../../../config/environment', __FILE__)

abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/test/fixtures"
  config.include FactoryGirl::Syntax::Methods

  config.before :suite, type: :feature do
    if ENV['DRIVER'] == 'selenium'
      require 'selenium-webdriver'
      Capybara.register_driver :selenium_chrome do |app|
        Capybara::Selenium::Driver.new(app, browser: :chrome)
      end
    else
      require 'capybara/poltergeist'
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, js_errors: false, inspector: true,
                                               phantomjs_options: ['--ignore-ssl-errors=yes'], timeout: 120)
      end
    end
    Capybara.default_max_wait_time = 5
  end

  config.before :each, type: :feature do
    Capybara.current_driver = ENV['DRIVER'] == 'selenium' ? :selenium_chrome : :poltergeist
  end

  config.include Capybara::DSL
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

end
