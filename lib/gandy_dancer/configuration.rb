module GandyDancer
  class Configuration
    attr_reader :db, :rails, :dependencies
    def initialize(configuration)
      configuration.symbolize_keys!
      @db = configuration.delete(:db)
      @rails = configuration.delete(:rails)
      @dependencies = configuration.values.flatten
    end

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
