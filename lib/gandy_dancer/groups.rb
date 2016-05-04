require 'singleton'
require 'forwardable'

module GandyDancer
  class Groups
    include Singleton
    extend SingleForwardable
    def_delegator :instance, :find_groups_for_gem

    include Contracts::Core

    Contract String => C::Maybe[C::ArrayOf[String], Array]
    def find_groups_for_gem(gem_name)
      groups.select { |gr| gr.gem?(gem_name) }.map(&:name)
    end

    Contract nil => C::ArrayOf[Group]
    def groups
      @groups ||= GandyDancer.load_yml('groups').map do |k, v|
        Group.new(k.to_sym, v)
      end
    end
  end
end
