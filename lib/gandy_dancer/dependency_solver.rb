module GandyDancer
  class DependencySolver
    def self.solve(dependencies)
      new(mapper_file_path).solve(dependencies)
    end

    def self.mapper_file_path
      "#{GandyDancer.root}/dependency_mapper.yml"
    end

    def initialize(mapper_file_path)
      @mapper_file_path = mapper_file_path
    end

    def solve(dependencies)
      remapping(split_config_values(dependencies))
    end

    private

    def dependency_mapper
      @dependency_mapper ||= begin
        YAML.load(File.read(@mapper_file_path))
            .transform_keys { |k| k.is_a?(Array) ? k.sort : k }
            .transform_values { |v| [*v] }
      end
    end

    def split_config_values(dependencies)
      dependencies.flat_map do |target|
        if target['+']
          target_paths = target.split('+')
          target_paths + (2..target_paths.size).flat_map do |i|
            target_paths.combination(i).to_a
          end
        else
          target
        end
      end
    end

    def remapping(gem_names)
      gem_names.flat_map do |g|
        if g.is_a?(Array)
          dependency_mapper[g.sort]
        else
          dependency_mapper.key?(g) ? dependency_mapper[g] : g
        end
      end.compact
    end
  end
end
