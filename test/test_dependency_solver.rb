require 'test/test_helper'

describe GandyDancer::DependencySolver do
  describe '#solve' do
    it 'manage dependencies in right ordef' do
      mapper_file_path = "#{File.dirname(__FILE__)}/data/dependency_mapper.yml"
      ds = GandyDancer::DependencySolver.new(mapper_file_path)
      dependencies = %w(trailblazer+cells dotenv sidekiq devise es6
                        foundation+slim+simple_form autoprefixer-rails)
      solved = %w(trailblazer-rails cells dotenv-rails sidekiq devise es6
                  foundation-rails slim-rails simple_form foundation+slim
                  foundation+simple_form autoprefixer-rails)
      assert_equal(solved, ds.solve(dependencies))
    end
  end
end
