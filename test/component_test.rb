require 'test/test_helper'

describe GandyDancer::Component do
  subject { GandyDancer::Component.new('rails', version: 5) }
  describe '.name' do
    it 'return component name' do
      assert_equal('rails', subject.name)
    end
  end
  describe '.params' do
    it 'return component params' do
      assert_equal({ version: 5 }, subject.params)
    end
  end
end
