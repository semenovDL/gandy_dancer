require 'forwardable'

module GandyDancer
  # wrap rails template logic and increase its functionality
  class TemplateWrapper
    extend Forwardable
    def_delegators :@context, :gsub_file, :run,
                   :create_file, :insert_into_file, :append_to_file

    def initialize(context)
      unless context.is_a?(Rails::Generators::AppGenerator)
        raise "wrong context #{context.class}"
      end
      @context = context
    end

    def gsub(data)
      data.each_pair do |file, file_data|
        file_data.each do |line|
          gsub_file(file, line['from'], line['to'])
        end
      end
    end

    def rm(data)
      data.each { |file| run "rm #{file}" }
    end

    def rm_rf(data)
      data.each { |file| run "rm -rf #{file}" }
    end

    def create(data)
      data.each_pair { |file, file_data| create_file(file, file_data) }
    end

    def insert(data)
      data.each_pair do |file, file_data|
        params = {}
        params[:after] = file_data['after'] if file_data['after']
        params[:before] = file_data['before'] if file_data['before']
        insert_into_file(file, file_data['data'], params)
      end
    end

    def append(data)
      data.each_pair do |file, file_data|
        append_to_file(file, file_data)
      end
    end

    # def generate(data)
    #   [*data].each { |c| @context.generate(*c) }
    # end
  end
end
