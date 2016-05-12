require 'thor'

module GandyDancer
  class CLI < Thor
    shared_options = {
      rails: {
        aliases: '-r',
        type: :numeric, default: 4, enum: [4, 5],
        desc: 'Major Ruby on Rails version'
      },
      database: {
        aliases: '-d',
        type: :string, default: 'postgresql', enum: %w(postgresql mysql sqlite),
        desc: 'Default database'
      },
      javascript: {
        type: :string, default: 'es6', enum: %w(es6 coffeescript typescript),
        desc: 'Javascript engine'
      },
      css_framework: {
        type: :string, default: 'foundation', enum: %w(bootstrap foundation),
        desc: 'Responsive CSS framework'
      },
      forms: {
        type: :string, default: 'simple_form', enum: %w(simple_form formtastic),
        desc: 'Form builder'
      },
      template_engine: {
        type: :string, default: 'slim', enum: %w(erb slim haml),
        desc: 'Template engine for views'
      },
      test_framework: {
        type: :string, default: 'minitest', enum: %w(minitest rspec),
        desc: 'Test framework'
      }
    }

    desc 'build APP_NAME', 'build application'
    shared_options.each_pair { |meth, params| method_option(meth, params) }
    method_option :force, aliases: '-f', type: :boolean, default: false,
                          desc: 'Remove target folder with project before build'
    def build(project_path)
      GandyDancer.check_ruby_version
      project = Project.register(project_path)
      project.prepare(options[:force])
      BuildTarget.setup(options.symbolize_keys.merge(project: project))
      GandyDancer.build_app
    end

    desc 'rebuild APP_NAME', 'force rebuild application'
    shared_options.each_pair { |meth, params| method_option(meth, params) }
    method_option :force, aliases: '-f', type: :boolean, default: true,
                          desc: 'Remove target folder with project before build'
    def rebuild(project_path)
      build(project_path)
    end

    no_commands do
      # TODO: Implement project update
      desc 'update APP_NAME', 'update existing application'
      def update(project_path)
      end
    end
  end
end
