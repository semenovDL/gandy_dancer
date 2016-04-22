module GandyDancer
  class Configuration
    attr_reader :db, :rails, :dependencies
    def initialize(configuration)
      @db = configuration.delete(:db)
      @rails = configuration.delete(:rails)
      @dependencies = configuration.values.flatten
    end

    def targets
      @targets ||= DependencySolver.solve(dependencies)
    end

    def to_h
      {
        db: db,
        rails: rails,
        dependencies: dependencies,
        targets: targets
      }
    end

    def self.load(configuration_file)
      new(YAML.load(File.read(configuration_file)).symbolize_keys)
    end
  end
end
