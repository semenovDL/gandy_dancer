module GandyDancer
  class Group
    include Contracts::Core

    attr_reader :name
    Contract Symbol, C::ArrayOf[String] => C::Any
    def initialize(name, gems)
      @name = name
      @gems = gems
    end

    Contract String => C::Bool
    def gem?(gem_name)
      @gems.include?(gem_name)
    end
  end
end
