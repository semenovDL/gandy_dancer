require 'test/test_helper'

describe GandyDancer::TemplateWrapper do
  module Rails
    module Generators
      class AppGenerator
      end
    end
  end
  let(:context) { Rails::Generators::AppGenerator.new }
  subject { GandyDancer::TemplateWrapper.new(context) }

  describe '.gsub' do
    it 'make multiple replaces' do
      data = {
        'file1' => [
          { 'from' => 'hello', 'to' => 'hell' },
          { 'from' => 'good', 'to' => 'bad' }
        ],
        'file2' => [{ 'from' => 'ok', 'to' => 'go' }]
      }
      context.expects(:gsub_file).with('file1', 'hello', 'hell')
      context.expects(:gsub_file).with('file1', 'good', 'bad')
      context.expects(:gsub_file).with('file2', 'ok', 'go')
      subject.gsub(data)
    end
  end

  describe '.rm' do
    it 'remove all given files' do
      context.expects(:run).with('rm file1')
      context.expects(:run).with('rm file2')
      context.expects(:run).with('rm file3')
      subject.rm(%w(file1 file2 file3))
    end
  end

  describe '.rm_rf' do
    it 'force remove all given files' do
      context.expects(:run).with('rm -rf file1')
      context.expects(:run).with('rm -rf file2')
      context.expects(:run).with('rm -rf file3')
      subject.rm_rf(%w(file1 file2 file3))
    end
  end

  describe '.create' do
    it 'create given files' do
      data = {
        'file1' => 'Some text',
        'file2' => 'More text'
      }
      context.expects(:create_file).with('file1', 'Some text')
      context.expects(:create_file).with('file2', 'More text')
      subject.create(data)
    end
  end

  describe '.insert' do
    it 'insert data to end of file' do
      data = {
        'file1' => { 'data' => 'Some text' },
        'file2' => { 'data' => 'More text' }
      }
      context.expects(:insert_into_file).with('file1', 'Some text', {})
      context.expects(:insert_into_file).with('file2', 'More text', {})
      subject.insert(data)
    end
    it 'insert data after text in file' do
      data = {
        'file1' => { 'data' => 'More text', 'after' => 'Some text' }
      }
      context.expects(:insert_into_file).with('file1', 'More text', after: 'Some text')
      subject.insert(data)
    end
    it 'insert data before text in file' do
      data = {
        'file1' => { 'data' => 'More text', 'before' => 'Some text' }
      }
      context.expects(:insert_into_file).with('file1', 'More text', before: 'Some text')
      subject.insert(data)
    end
  end

  describe '.append' do
    it 'add data to file' do
      data = {
        'file1' => 'Some text',
        'file2' => 'More text'
      }
      context.expects(:append_to_file).with('file1', 'Some text')
      context.expects(:append_to_file).with('file2', 'More text')
      subject.append(data)
    end
  end
end
