require 'test/test_helper'

describe GandyDancer::Group do
  subject { GandyDancer::Group }
  describe '#find_groups' do
    it 'return groups for gem' do
      GandyDancer.stub(:root, "#{File.dirname(__FILE__)}/data") do
        assert_equal([:development, :test], subject.find_groups('dotenv-rails'))
        assert_equal([:test], subject.find_groups('simplecov'))
        assert_equal([], subject.find_groups('unknown'))
      end
    end
  end
end
