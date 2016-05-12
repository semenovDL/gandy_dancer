module GandyDancer
  class Gem
    include Contracts::Core

    attr_reader :name
    Contract String => C::Any
    def initialize(name)
      @name = name
    end

    Contract nil => String
    def version
      @version ||= Components.get(name.to_sym).params['version']
    end

    Contract nil => C::Bool
    def installed?
      dep = ::Gem::Dependency.new(name, version)
      Gems.installed_versions_of(name).any? { |v| dep.match?(name, v) }
    end

    Contract nil => C::Bool
    def install
      return true if installed?
      system("gem install #{name} -v #{version}")
    end
  end
end
