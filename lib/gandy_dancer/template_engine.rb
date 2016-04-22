module GandyDancer
  class TemplateEngine
    class << self
      def root
        GandyDancer.root
      end

      def template_file
        "#{root}/template.rb"
      end

      def gems
        @gems ||= YAML.load(File.read("#{root}/default.yml"))
      end

      def config
        @config ||= YAML.load(File.read("#{root}/config.yml"))
      end

      def gem_version(gem_name)
        gems['core'][gem_name]['version']
      end

      def gem_list
        `gem list`.split("\n").map(&:strip)
      end

      def installed_gems
        @installed_gems ||= begin
          gem_list.each_with_object({}) do |line, res|
            data = line.match(/^(?<gem>\S+) \((?<versions>.+)\)/)
            res[data[:gem]] = data[:versions].split(', ')
          end
        end
      end

      def check_gem(gem_name, version)
        dep = Gem::Dependency.new(gem_name, version)
        installed_gems[gem_name].any? { |v| dep.match?(gem_name, v) }
      end

      def install_gem(gem_name)
        version = gem_version(gem_name)
        return if check_gem(gem_name, version)
        system("gem install #{gem_name} -v #{version}")
      end

      def start(app_name)
        install_gem('rails')
        require 'rails/generators/rails/app/app_generator'
        Rails::Generators::AppGenerator.start [
          app_name,
          '-m', template_file,
          '-d', config['db']
        ]
      end
    end
  end
end
