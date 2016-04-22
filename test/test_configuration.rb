require 'test/test_helper'

describe GandyDancer::Configuration do
  describe '#load' do
    it 'load configuration from given file' do
      GandyDancer.stub(:root, "#{File.dirname(__FILE__)}/data") do
        configuration_file = "#{GandyDancer.root}/configuration.yml"
        configuration = GandyDancer::Configuration.load(configuration_file)
        dependencies = %w(trailblazer+cells dotenv sidekiq devise es6
                          foundation+slim+simple_form autoprefixer-rails)
        assert_equal('postgresql', configuration.db)
        assert_equal(5, configuration.rails)
        assert_equal(dependencies, configuration.dependencies)
      end
    end
  end
end
