require 'test/test_helper'

describe GandyDancer::Components do
  describe '#get' do
    it 'return component' do
      GandyDancer.expects(:rails_version).at_least(0).returns(5)
      component = GandyDancer::Components.get(:rails)
      assert_instance_of(GandyDancer::Component, component)
    end
  end
end
