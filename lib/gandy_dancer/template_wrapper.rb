require 'forwardable'

module GandyDancer
  # wrap rails template logic and increase its functionality
  class TemplateWrapper
    extend Forwardable
    include Contracts::Core
    def_delegators :@context, :gsub_file, :run,
                   :create_file, :insert_into_file, :append_to_file

    def initialize(context)
      unless context.is_a?(Rails::Generators::AppGenerator)
        raise "wrong context #{context.class}"
      end
      @context = context
    end

    Contract C::HashOf[String => C::ArrayOf[C::HashOf[String => String]]] => C::Any
    def gsub(data)
      data.each_pair do |file, file_data|
        file_data.each do |line|
          gsub_file(file, line['from'], line['to'])
        end
      end
    end

    Contract C::ArrayOf[String] => C::Any
    def rm(data)
      data.each { |file| run "rm #{file}" }
    end

    Contract C::ArrayOf[String] => C::Any
    def rm_rf(data)
      data.each { |file| run "rm -rf #{file}" }
    end

    Contract C::HashOf[String => String] => C::Any
    def create(data)
      data.each_pair { |file, file_data| create_file(file, file_data) }
    end

    Contract C::HashOf[String => C::HashOf[String => String]] => C::Any
    def insert(data)
      data.each_pair do |file, file_data|
        params = {}
        params[:after] = file_data['after'] if file_data['after']
        params[:before] = file_data['before'] if file_data['before']
        insert_into_file(file, file_data['data'], params)
      end
    end

    Contract C::HashOf[String => String] => C::Any
    def append(data)
      data.each_pair do |file, file_data|
        append_to_file(file, file_data)
      end
    end

    # Contract String => C::Any
    def generate(data)
      [*data].each { |c| @context.generate(*c) }
    end
  end
end
