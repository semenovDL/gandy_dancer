require 'test/test_helper'

describe GandyDancer::Groups do
  subject { GandyDancer::Groups }
  describe '#find_groups_for_gem' do
    it 'return groups for gem' do
      assert_equal([:development, :test], subject.find_groups_for_gem('dotenv-rails'))
      assert_equal([:test], subject.find_groups_for_gem('simplecov'))
      assert_equal([], subject.find_groups_for_gem('unknown'))
    end
  end
end
