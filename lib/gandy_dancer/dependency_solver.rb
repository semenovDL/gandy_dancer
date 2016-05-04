require 'singleton'
require 'forwardable'

module GandyDancer
  class DependencySolver
    include Singleton
    extend SingleForwardable
    def_delegator :instance, :solve

    include Contracts::Core

    Contract C::ArrayOf[String] => C::ArrayOf[Component]
    def solve(dependencies)
      remapping(split_config_values(dependencies)).map do |component|
        Components.get(component)
      end
    end

    private

    def dependency_mapper
      @dependency_mapper ||= begin
        GandyDancer.load_yml('dependency_mapper')
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
      end.compact.map(&:to_sym)
    end
  end
end
