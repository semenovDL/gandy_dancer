module GandyDancer
  # Project describes rails application, choosen as target
  class Project
    attr_reader :path
    def initialize(path)
      raise 'Project path not provided' unless path
      @path = path
    end

    def prepare(delete_flag = false)
      return unless File.directory?(path)
      stop
      delete if delete_flag
    end

    private

    def stop
      Dir.chdir(path) do
        exec('bin/spring stop') if File.file?('bin/spring')
      end
    end

    def delete
      Dir.chdir(path) do
        entries = Dir.glob('*', File::FNM_DOTMATCH) - %w(. .. .gandy_dancer.yml)
        FileUtils.rm_rf(entries)
      end
    end

    class << self
      def projects
        @projects ||= []
      end

      def register(path)
        new(path).tap { |project| projects << project }
      end
    end
  end
end
