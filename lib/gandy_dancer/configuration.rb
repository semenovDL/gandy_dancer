module GandyDancer
  class Configuration
    include Contracts::Core
    attr_reader :db, :rails, :dependencies

    Contract Hash => C::Any
    def initialize(configuration)
      configuration.symbolize_keys!
      @db = configuration.delete(:db)
      @rails = configuration.delete(:rails)
      @dependencies = (configuration.values.flatten << 'rails')
    end

    Contract nil => C::ArrayOf[Component]
    def components
      @components ||= DependencySolver.solve(dependencies)
    end

    def to_h
      {
        db: db,
        rails: rails,
        dependencies: dependencies,
        components: components
      }
    end
  end
end
