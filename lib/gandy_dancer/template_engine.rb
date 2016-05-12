module GandyDancer
  class TemplateEngine
    class << self
      def template_file
        "#{GandyDancer.root}/template.rb"
      end

      def start
        app_name = Project.projects.first.path
        Gem.new('rails').install
        require 'rails/generators/rails/app/app_generator'
        Rails::Generators::AppGenerator.start [
          app_name,
          '-m', template_file,
          '-d', BuildTarget.database
        ]
      end
    end
  end
end
