module GandyDancer
  class Target
    attr_reader :name
    def initialize(name)
      @name = name
    end

    def data
      @data ||= self.class.target_data(self)
    end

    class << self
      def target_data(target)
        target_name = target.name
        if targets.key?(target_name)
          targets[target_name]
        else
          raise "No configuration for target #{target_name}"
        end
      end

      def targets
        @targets ||= YAML.load(File.read("#{GandyDancer.root}/default2.yml"))
      end
    end
  end
end
