require 'test/test_helper'

describe GandyDancer::DependencySolver do
  describe '#solve' do
    it 'manage dependencies in right ordef' do
      GandyDancer.expects(:rails_version).at_least(0).returns(5)
      ds = GandyDancer::DependencySolver
      dependencies = %w(
        trailblazer+cells dotenv sidekiq devise es6
        foundation+slim+simple_form autoprefixer-rails
      )
      expected_names = %w(
        trailblazer-rails cells dotenv-rails sidekiq devise es6
        foundation-rails slim-rails simple_form foundation+slim
        foundation+simple_form autoprefixer-rails
      ).map(&:to_sym)
      solved = ds.solve(dependencies)
      assert_instance_of(Array, solved)
      assert_instance_of(GandyDancer::Component, solved.first)
      assert_equal(expected_names, solved.map(&:name))
    end
  end
end
