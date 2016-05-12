require 'singleton'
require 'forwardable'

module GandyDancer
  # List of available components
  class Components
    include Singleton
    extend SingleForwardable
    def_delegator :instance, :get

    include Contracts::Core

    Contract Symbol => Component
    def get(name)
      components[name] || raise("No component for name #{name}")
    end

    private

    def components
      @components ||= files_data.each_with_object({}) do |(name, params), result|
        result[name] ||= Component.new(name, params)
      end
    end

    def files
      %W(default rails_#{GandyDancer.rails_version})
        .map { |file_name| "components/#{file_name}" }
    end

    def files_data
      files.inject({}) do |acc, file|
        acc.merge! GandyDancer.load_yml(file).symbolize_keys
      end
    end
  end
end
