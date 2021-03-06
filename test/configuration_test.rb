require 'test/test_helper'

describe GandyDancer::Configuration do
  subject do
    GandyDancer::Configuration.new(
      db: 'pg',
      rails: 5,
      authentification: %w(devise),
      frontend: %w(es6 foundation+slim+simple_form)
    )
  end

  describe '.db' do
    it { assert_equal('pg', subject.db) }
  end

  describe '.rails' do
    it { assert_equal(5, subject.rails) }
  end

  describe '.dependencies' do
    it 'return flatten list of all dependencies' do
      dependencies = %w(devise es6 foundation+slim+simple_form rails)
      assert_equal(dependencies, subject.dependencies)
    end
  end

  describe '.components' do
    it 'try to solve dependencies using DependencySolver' do
      components = [GandyDancer::Component.new('', '')]
      GandyDancer::DependencySolver.expects(:solve).with(subject.dependencies)
                                   .returns(components)
      assert_instance_of(GandyDancer::Component, subject.components.first)
    end
  end
end
