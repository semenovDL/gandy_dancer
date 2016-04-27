module GandyDancer
  class Group
    attr_reader :name
    def initialize(name, gems)
      @name = name
      @gems = gems
    end

    def gem?(gem_name)
      @gems.include?(gem_name)
    end
  end
end
