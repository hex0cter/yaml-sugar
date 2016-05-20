require 'find'
require 'yaml'
require 'ostruct'
require 'hashugar'
require 'deep_merge'

module YamlSugar
  # SugarImpl class
  class SugarImpl
    attr_reader :config
    extend Gem::Deprecate

    def initialize
      @config = OpenStruct.new
    end

    def method_missing(method_sym, *args)
      if @config.respond_to? method_sym
        @config.send method_sym, *args
      elsif method_sym.to_s.end_with?('=')
        @config.send method_sym, *args
      elsif method_sym == :clear
        @config = OpenStruct.new
      else
        nil
      end
    end

    def set(attr, value)
      @config.send("#{attr}=", value)
    end

    def load(dir, args = {})
      deep_merge = args.fetch :deep_merge, false
      fail "Parameter #{File.join(Dir.pwd, dir)} is not a valid directory" unless File.directory? dir

      @yaml_files ||= []
      Find.find(dir) do |yaml_file|
        next unless yaml_file =~ /.*\.yml$/ or yaml_file =~ /.*\.yaml$/
        new_config = YAML.load_file(yaml_file)

        attr_name = File.basename(yaml_file, File.extname(yaml_file)).to_sym
        if @config.respond_to?(attr_name)
          old_config = @config.send(attr_name).to_hash
          new_config = if deep_merge
                         new_config.deep_merge(old_config)
                       else
                         old_config.merge(new_config)
                       end
        end
        @config.send("#{attr_name}=", new_config.to_hashugar)
      end
    end
  end
end
