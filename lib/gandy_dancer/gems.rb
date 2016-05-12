require 'singleton'
require 'forwardable'

module GandyDancer
  class Gems
    include Contracts::Core

    include Singleton
    extend SingleForwardable
    def_delegator :instance, :installed_versions_of

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

    Contract String => C::ArrayOf[String]
    def installed_versions_of(gem_name)
      installed_gems[gem_name]
    end
  end
end
