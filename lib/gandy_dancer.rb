$LOAD_PATH << File.dirname(__FILE__)

require 'yaml'
require 'commons/hash/deep_merge'
require 'commons/hash/keys'
require 'commons/hash/transform_values'

Dir.glob("#{File.dirname(__FILE__)}/gandy_dancer/*").each { |f| require f }

module GandyDancer
  class << self
    attr_accessor :root
    def root
      @root ||= File.expand_path('../../', __FILE__)
    end

    def config_path
      "#{root}/config"
    end

    def ruby_version
      File.read("#{root}/.ruby-version").strip
    end

    def check_ruby_version
      raise "Wrong ruby #{RUBY_VERSION}" if RUBY_VERSION != ruby_version
    end

    def rails_version
      Build.rails
    end

    def build_app
      project_path = Build.project.path
      puts configuration = Configuration.load("#{config_path}/default.yml")
      puts targets = configuration.targets.map { |t| Target.new(t) }.map(&:data)
      # TemplateEngine.start(project_path)
    end
  end
end
