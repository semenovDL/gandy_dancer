require 'yaml'

module GandyDancer
  class Actions
    attr_reader :name, :params
    def initialize(name, params)
      @name = name
      @params = params
    end

    class << self
      def actions_path
        "#{GandyDancer.config_path}/actions"
      end

      def actions_files
        %W(default rails_#{GandyDancer.rails_version}).map do |file_name|
          "#{actions_path}/#{file_name}.yml"
        end
      end

      def actions_data
        actions_files.inject({}) do |acc, file|
          acc.merge! YAML.load(File.read(file)).symbolize_keys
        end
      end

      def actions
        @actions ||= actions_data.each_with_object({}) do |(name, data), result|
          result[name] = new(name, data)
        end
      end
    end
  end
end
