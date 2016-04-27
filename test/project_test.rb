require 'test/test_helper'

describe GandyDancer::Project do
  subject { GandyDancer::Project.new(@project_dir) }
  before do
    @root = "#{File.dirname(__FILE__)}/data"
    @project_dir = "#{@root}/awesome_project"
    FileUtils.mkdir_p @project_dir
  end
  after do
    FileUtils.rm_rf @project_dir
  end

  describe '#register' do
    it 'create new object and store it' do
      obj = GandyDancer::Project.register('path/to/project')
      assert_instance_of(GandyDancer::Project, obj)
      assert_equal('path/to/project', obj.path)
      assert_equal(1, GandyDancer::Project.projects.size)
      assert_equal(obj, GandyDancer::Project.projects.first)
    end
  end

  describe '.prepare' do
    it 'try to stop application' do
      FileUtils.mkdir_p "#{@project_dir}/bin"
      FileUtils.touch "#{@project_dir}/bin/spring"
      subject.expects(:exec).with('bin/spring stop')
      Dir.chdir(@root) do
        subject.prepare
      end
    end

    it 'try to clean application folder with force flag' do
      FileUtils.touch "#{@project_dir}/file"
      Dir.chdir(@root) do
        subject.prepare(true)
      end
      assert_equal(false, File.exist?("#{@project_dir}/file"))
    end
  end
end
