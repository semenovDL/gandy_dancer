module GandyDancer
  class Group
    def self.find_groups(gem_name)
      groups.select { |_, v| v.include?(gem_name) }.keys
    end

    def self.groups_file
      "#{GandyDancer.root}/groups.yml"
    end

    def self.groups
      @groups ||= YAML.load(File.read(groups_file)).symbolize_keys
    end
  end
end
