require 'test/test_helper'

module GandyDancer
  class BuildTarget
    def to_str
      'GandyDancer::BuildTarget'
    end
  end
end

describe GandyDancer::BuildTarget do
  subject { GandyDancer::BuildTarget }
  describe '.setup' do
    it 'initialize build target with command line params' do
      subject.setup(a: 1, b: 2)
      assert_equal(1, subject.a)
      assert_equal(2, subject.b)
    end
  end
end
