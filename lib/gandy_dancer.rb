$LOAD_PATH << File.dirname(__FILE__)

require 'yaml'
require 'commons/hash/deep_merge'
require 'commons/hash/keys'
require 'commons/hash/transform_values'
require 'contracts'
C = Contracts

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

    def load_yml(file_name)
      YAML.load(File.read("#{config_path}/#{file_name}.yml"))
    end

    def ruby_version
      File.read("#{root}/.ruby-version").strip
    end

    def check_ruby_version
      raise "Wrong ruby #{RUBY_VERSION}" if RUBY_VERSION != ruby_version
    end

    def rails_version
      @rails_version ||= BuildTarget.rails
    end

    def build_app
      configuration_file = load_yml('default')
      Configuration.new(configuration_file)
      TemplateEngine.start
    end
  end
end
