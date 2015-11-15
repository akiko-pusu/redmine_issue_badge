require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')
require File.expand_path("../../../../config/environment", __FILE__)
require 'rspec/rails'
require 'simplecov'
SimpleCov.start 'rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.include FactoryGirl::Syntax::Methods
  FactoryGirl.definition_file_paths = [File.expand_path("../factories", __FILE__)]
  FactoryGirl.find_definitions
  config.before(:all) do
    FactoryGirl.reload
  end
end
