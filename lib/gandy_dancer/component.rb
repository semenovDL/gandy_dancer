module GandyDancer
  # Component describe gem and its actions
  class Component
    attr_reader :name, :params
    def initialize(name, params)
      @name = name
      @params = params
    end
  end
end
