def source_paths
  ["#{GandyDancer.root}/templates"]
end

git :init

command_wrapper = GandyDancer::BuildCommand.new(self)

config_file = File.expand_path('../default.yml', __FILE__)
config = YAML.load(File.read(config_file))
config.delete('core')
config.each_pair do |group, group_data|
  groups = []
  groups << :test if group == 'test'
  groups << :development if group == 'tools'
  groups = [:development, :test] if group == 'environments'
  gems = []
  group_data.delete_if { |_gem_name, gem_data| gem_data['disable'] }
  group_data.each_pair do |gem_name, gem_data|
    version = gem_data.delete('version')
    next unless version
    required = gem_data.delete('require')
    gem_params = [gem_name, version]
    gem_params << { require: required } if required
    gems << gem_params
  end
  init_gems = ->() { gems.each { |params| gem(*params) } }
  groups.any? ? gem_group(*groups) { init_gems.call } : init_gems.call

  group_data.each_pair do |_, gem_data|
    after_bundle_data = gem_data.delete('after_bundle')
    if after_bundle_data
      after_bundle do
        after_bundle_data.each_pair do |command, command_data|
          command_wrapper.send(command.to_sym, command_data)
        end
      end
    end
    gem_data.each_pair do |command, command_data|
      command_wrapper.send(command.to_sym, command_data)
    end
  end
end

copy_file 'fast', 'bin/fast'

after_bundle do
  rake 'db:migrate'
  git add: '.'
  git commit: "-am 'Initial commit'"
end

# commit 'inherited_resources', gem: true
# commit 'poltergeist', gem: true, group: :test
# commit 'rollbar', gem: true
#
# commit 'Procfile' do
#   file 'Procfile', <<-PROCFILE
# db: postgres -D /usr/local/var/postgres
# web: rails s
#   PROCFILE
# end
#
# commit 'db:bootstrap task' do
#   file 'lib/tasks/bootstrap.rake', <<-TASK
# namespace :db do
#   desc 'Bootstraps with demo data'
#   task bootstrap: :environment do
#   end
# end
#   TASK
# end
#
# commit 'factories file' do
#   file 'spec/support/factories.rb', <<-FACTORIES
# FactoryGirl.define do
# end
#   FACTORIES
# end
#
# application <<-GENERATORS
#     config.generators do |g|
#       g.assets false
#       g.helper false
#       g.controller_specs false
#       g.view_specs false
#     end
# GENERATORS
# git add: '.'
# git commit: "-am 'configure generators'"
#
# after_bundle do
#   rake "db:migrate"
#   git add: '.'
#   git commit: "-am 'migrate database'"
#
#   git add: '.'
#   git commit: "-am 'install binstubs'"
# end
