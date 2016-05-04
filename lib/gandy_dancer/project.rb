module GandyDancer
  # Project describes rails application, choosen as target
  class Project
    include Contracts::Core
    extend Contracts::Core

    attr_reader :path

    Contract String => C::Any
    def initialize(path)
      @path = path
    end

    Contract C::Bool => Project
    def prepare(delete_flag = false)
      return unless File.directory?(path)
      stop
      delete if delete_flag
      self
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
      Contract nil => C::Maybe[C::ArrayOf[Project], Array]
      def projects
        @projects ||= []
      end

      Contract String => Project
      def register(path)
        new(path).tap { |project| projects << project }
      end
    end
  end
end
