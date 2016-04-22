require 'singleton'

module GandyDancer
  class Build
    include Singleton
    attr_accessor :params
    def method_missing(name, *args, &block)
      params.key?(name) ? params[name] : super
    end

    def respond_to_missing?(meth_name, include_all)
      params.key?(meth_name) || super
    end

    class << self
      def setup(params)
        instance.params = params.to_hash.symbolize_keys.freeze
      end

      def method_missing(name, *args, &block)
        instance.respond_to?(name) ? instance.send(name, *args, &block) : super
      end

      def respond_to_missing?(meth_name, include_all)
        instance.respond_to?(meth_name) || super
      end
    end
  end
end
